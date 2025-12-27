#!/usr/bin/with-contenv bashio

# =========================================
# Configurazione FTP / SSL / LFTP
# =========================================
echo "set ssl:verify-certificate no" > ~/.lftprc
echo "set ssl:check-hostname no" >> ~/.lftprc
echo "set ftp:passive-mode on" >> ~/.lftprc
echo "set ftp:ssl-allow yes" >> ~/.lftprc
echo "set cmd:verbose no" >> ~/.lftprc

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
        lftp -u "${USER},${PASS}" ftp://"${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
        bashio::log.info "Sincronizzazione completata"
    else
        bashio::log.info "Eseguo mirror periodico ogni ${INTERVAL} secondi..."
        while true; do
            lftp -u "${USER},${PASS}" ftp://"${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
            bashio::log.info "Attendo ${INTERVAL} secondi prima del prossimo mirror..."
            sleep "${INTERVAL}"
        done
    fi

# =========================================
# Modalità stdin (FIFO) per comandi dall'automazione
# =========================================
else
    bashio::log.info "--- MOTORE LFTP PRONTO A RICEVERE COMANDI ---"

    # Creazione FIFO per comandi
    FIFO_CMD="/tmp/lftp_fifo"
    [[ ! -p "$FIFO_CMD" ]] && mkfifo "$FIFO_CMD"

    # Avvio LFTP in background, stdout line-buffered
    # Tutto l'output di LFTP viene catturato dal while read
    stdbuf -oL lftp -u "${USER},${PASS}" ftp://"${HOST}" < "$FIFO_CMD" 2>&1 | while read -r LINE; do
        bashio::log.info "[LFTP] $LINE"
    done &

    # Loop per leggere input dall'automazione
    while read -r CMD; do
        [[ -z "$CMD" ]] && continue

        # Rimuove eventuali virgolette
        CMD="${CMD%\"}"
        CMD="${CMD#\"}"

        bashio::log.info "Invio comando: $CMD"
        echo "$CMD" > "$FIFO_CMD"
    done
fi
