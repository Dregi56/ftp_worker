#!/usr/bin/with-conten-env bashio

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

# Recupera configurazioni
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "Connesso a: ${HOST}"

# Loop infinito per restare attivo
while read -r input; do
    bashio::log.info "Eseguo: $input"
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
