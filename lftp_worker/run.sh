#!/usr/bin/with-contenv bashio

# =========================================
# Configurazione LFTP
# =========================================
echo "set ssl:verify-certificate no" > ~/.lftprc
echo "set ssl:check-hostname no" >> ~/.lftprc
echo "set ftp:passive-mode on" >> ~/.lftprc
echo "set ftp:ssl-allow yes" >> ~/.lftprc
echo "set cmd:verbose no" >> ~/.lftprc

bashio::log.info "--- ADDON LFTP AVVIATO ---"

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

# =========================================
# Funzione: avvio motore LFTP interattivo
# =========================================
start_interactive_lftp() {
    bashio::log.info "--- MOTORE LFTP INTERATTIVO ATTIVO ---"

    FIFO_CMD="/tmp/lftp_fifo"
    [[ ! -p "$FIFO_CMD" ]] && mkfifo "$FIFO_CMD"

    # Avvio sessione LFTP persistente
    lftp -u "${USER},${PASS}" ftp://"${HOST}" < "$FIFO_CMD" 2>&1 | \
    while read -r LINE; do
        bashio::log.info "[LFTP] $LINE"
    done &

    bashio::log.info "Sessione LFTP avviata, in ascolto di comandi stdin"

    # Loop di ascolto per comandi direttamente da stdin
    while read -r CMD; do
        [[ -z "$CMD" ]] && continue
        bashio::log.info ">> $CMD"
        printf "%s\n" "$CMD" > "$FIFO_CMD"
    done
}

# =========================================
# MIRROR AUTOMATICO (se configurato)
# =========================================
if [[ -n "$LOCAL_DIR" && -n "$REMOTE_DIR" ]]; then
    bashio::log.info "Modalità mirror automatico attiva"

    MIRROR_CMD="mirror --reverse"

    if [[ -n "$EXTENSIONS" ]]; then
        bashio::log.info "Filtro estensioni: ${EXTENSIONS}"
        MIRROR_CMD+=" --exclude-glob *"
        IFS=',' read -ra EXT_ARRAY <<< "$EXTENSIONS"
        for EXT in "${EXT_ARRAY[@]}"; do
            EXT=$(echo "$EXT" | xargs)
            MIRROR_CMD+=" --include-glob *.${EXT}"
        done
    fi

    if [[ -z "$INTERVAL" ]]; then
        bashio::log.info "Eseguo mirror singolo all'avvio"
        lftp -u "${USER},${PASS}" ftp://"${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
        bashio::log.info "Mirror completato"
    else
        bashio::log.info "Mirror periodico ogni ${INTERVAL} secondi"
        while true; do
            lftp -u "${USER},${PASS}" ftp://"${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
            bashio::log.info "Attendo ${INTERVAL}s prima del prossimo mirror"
            sleep "${INTERVAL}"
        done
    fi

    # Dopo il mirror, parte comunque il motore interattivo
    start_interactive_lftp

# =========================================
# SOLO MODALITÀ INTERATTIVA (nessun mirror)
# =========================================
else
    start_interactive_lftp
fi
