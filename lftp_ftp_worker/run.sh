#!/usr/bin/with-conten-env bashio

# Carica configurazioni usando bashio
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "--- MOTORE AVVIATO ---"
bashio::log.info "Connessione a: ${HOST}"

# Motore in ascolto di comandi
while read -r input; do
    bashio::log.info "Esecuzione comando: $input"
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
