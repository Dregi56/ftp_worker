#!/usr/bin/with-contenv bashio

# 1️⃣ Configurazione Aruba / SSL / FTP
echo "set ssl:verify-certificate no" > ~/.lftprc
echo "set ssl:check-hostname no" >> ~/.lftprc
echo "set ftp:passive-mode on" >> ~/.lftprc
echo "set ftp:ssl-allow yes" >> ~/.lftprc
echo "set cmd:verbose no" >> ~/.lftprc

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')
LOCAL_DIR=$(bashio::config 'local_dir')
REMOTE_DIR=$(bashio::config 'remote_dir')
INTERVAL=$(bashio::config 'interval')
EXTENSIONS=$(bashio::config 'extensions')

bashio::log.info "Connessione FTP verso ${HOST}"

if [[ -n "$LOCAL_DIR" && -n "$REMOTE_DIR" ]]; then
    bashio::log.info "Sincronizzazione automatica abilitata"

    # Costruisci comando mirror con eventuali filtri
    MIRROR_CMD="mirror --reverse"
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
        # Mirror singolo all’avvio
        bashio::log.info "Eseguo mirror una sola volta all'avvio..."
        lftp -u "${USER},${PASS}" "${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
        bashio::log.info "Sincronizzazione completata"
    else
        # Loop periodico
        bashio::log.info "Eseguo mirror ogni ${INTERVAL} secondi..."
        while true; do
            lftp -u "${USER},${PASS}" "${HOST}" -e "${MIRROR_CMD} \"${LOCAL_DIR}\" \"${REMOTE_DIR}\"; quit"
            bashio::log.info "Attendo ${INTERVAL} secondi prima del prossimo mirror..."
            sleep "${INTERVAL}"
        done
    fi

else
    # Modalità stdin
    bashio::log.info "--- MOTORE LFTP PRONTO A RICEVERE COMANDI ---"

    # Avvio LFTP come coprocesso, rimane aperto
    coproc LFTP_PROC { lftp -u "${USER},${PASS}" ftps://"${HOST}"; }

    # Leggi comandi dall'automazione e inviali al coprocesso
    while read -r CMD; do
        if [[ -n "$CMD" ]]; then
            bashio::log.info "Invio comando: $CMD"
            echo "$CMD" >&"${LFTP_PROC[1]}"
        fi
    done
fi
