#!/usr/bin/with-contenv bashio

# =========================================
# Configurazione FTP / SSL / LFTP
# =========================================
cat <<EOF > ~/.lftprc
set ssl:verify-certificate no
set ssl:check-hostname no
set ftp:passive-mode on
set ftp:ssl-allow yes
set cmd:verbose no
set cmd:interactive yes
set cmd:fail-exit no
EOF

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

# =========================================
# Config
# =========================================
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')
LOCAL_DIR=$(bashio::config 'local_dir')
REMOTE_DIR=$(bashio::config 'remote_dir')
INTERVAL=$(bashio::config 'interval')
EXTENSIONS=$(bashio::config 'extensions')

bashio::log.info "Connessione FTP verso ${HOST}"

# =========================================
# Mirroring automatico (se configurato)
# =========================================
if [[ -n "$LOCAL_DIR" && -n "$REMOTE_DIR" ]]; then
    bashio::log.info "Sincronizzazione automatica abilitata"

    MIRROR_CMD="mirror --reverse"

    # Filtro estensioni
    if [[ -n "$EXTENSIONS" ]]; then
        bashio::log.info "Filtro estensioni attivo: ${EXTENSIONS}"
        MIRROR_CMD+=" --exclude-glob *"
        IFS=',' read -ra EXT_ARRAY <<< "$EXTENSIONS"
        for EXT in "${EXT_ARRAY[@]}"; do
            EXT=$(echo "$EXT" | xargs)
            MIRROR_CMD+=" --include-glob *.${EXT}"
        done
    fi

    if [[ -z "$INTERVAL" ]]; then
        bashio::log.info "Eseguo mirror singolo all'avvio..."
        lftp -u "${USER},${PASS}" ftp://"${HOST}" \
            -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
        bashio::log.info "Sincronizzazione completata"
    else
        bashio::log.info "Eseguo mirror periodico ogni ${INTERVAL} secondi..."
        while true; do
            lftp -u "${USER},${PASS}" ftp://"${HOST}" \
                -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
            bashio::log.info "Attendo ${INTERVAL} secondi prima del prossimo mirror..."
            sleep "${INTERVAL}"
        done
    fi

# =========================================
# Modalità stdin persistente (Home Assistant)
# =========================================
else
    bashio::log.info "--- MOTORE LFTP PRONTO (SESSIONE PERSISTENTE) ---"

    FIFO_CMD="/tmp/lftp_fifo"
    [[ -p "$FIFO_CMD" ]] || mkfifo "$FIFO_CMD"

    # Apriamo il FIFO UNA SOLA VOLTA (FD 3)
    exec 3> "$FIFO_CMD"

    # Avvio LFTP persistente
    lftp -u "${USER},${PASS}" ftp://"${HOST}" < "$FIFO_CMD" 2>&1 | \
    while read -r LINE; do
        bashio::log.info "[LFTP] $LINE"
    done &

    # Loop stdin Home Assistant (CORRETTO)
    while bashio::addon.stdin CMD; do
        [[ -z "$CMD" ]] && continue

        # Pulizia input
        CMD="${CMD%\"}"
        CMD="${CMD#\"}"

        case "${CMD,,}" in
            quit|bye|exit)
                bashio::log.warning "Comando '${CMD}' ricevuto → chiusura controllata LFTP"

                echo "quit" >&3
                sleep 1

                bashio::log.info "Sessione LFTP chiusa. Arresto addon."
                exit 0
                ;;
        esac

        bashio::log.info "▶ LFTP CMD: $CMD"
        echo "$CMD" >&3
    done
fi
