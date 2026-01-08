#!/usr/bin/with-contenv bashio

# =========================================
# Configurazione LFTP / SSL
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
# Config utente
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
# Mirroring automatico all'avvio (se configurato)
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
# Modalità persistente con coda comandi interna
# =========================================
else
    bashio::log.info "--- MOTORE LFTP PRONTO (SESSIONE PERSISTENTE) ---"

    FIFO_CMD="/tmp/lftp_fifo"
    CMD_FILE="/tmp/lftp_commands.txt"

    # Creo FIFO e file coda se non esistono
    [[ ! -p "$FIFO_CMD" ]] && mkfifo "$FIFO_CMD"
    [[ ! -f "$CMD_FILE" ]] && touch "$CMD_FILE"

    exec 3> "$FIFO_CMD"

    # Avvio LFTP in background
    lftp -u "${USER},${PASS}" ftp://"${HOST}" < "$FIFO_CMD" 2>&1 | while read -r LINE; do
        bashio::log.info "[LFTP] $LINE"
    done &

    # =========================================
    # Loop principale: stdin + file coda interna
    # =========================================
    while true; do
        # 1️⃣ Leggo eventuali comandi inviati via addon_stdin
        if bashio::addon.stdin CMD; then
            [[ -z "$CMD" ]] || echo "$CMD" >> "$CMD_FILE"
        fi

        # 2️⃣ Leggo comandi dalla coda interna e li invio a LFTP
        if [[ -s "$CMD_FILE" ]]; then
            while read -r CMD_LINE; do
                [[ -z "$CMD_LINE" ]] && continue

                # Pulizia input
                CMD_LINE="${CMD_LINE%\"}"
                CMD_LINE="${CMD_LINE#\"}"

                case "${CMD_LINE,,}" in
                    quit|bye|exit)
                        bashio::log.warning "Comando '${CMD_LINE}' → chiusura LFTP"
                        echo "quit" >&3
                        sleep 1
                        exit 0
                        ;;
                esac

                bashio::log.info "▶ Eseguo comando: $CMD_LINE"
                echo "$CMD_LINE" >&3
            done < "$CMD_FILE"
            # Svuoto file dopo aver eseguito comandi
            > "$CMD_FILE"
        fi

        sleep 0.2
    done
fi
