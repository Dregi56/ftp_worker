#!/usr/bin/with-conten-env bashio

# Carica configurazioni
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "Avvio LFTP FTP Worker..."
bashio::log.info "Connessione a: ${HOST}"

# Motore in ascolto
while read -r input; do
    bashio::log.info "Esecuzione comando: $input"
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
