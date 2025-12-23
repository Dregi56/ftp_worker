#!/usr/bin/with-conten-env bashio

bashio::log.info "--- MOTORE LFTP AVVIATO (v1.0.23) ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "Connesso a: ${HOST}"

while read -r input; do
    bashio::log.info "Eseguo: $input"
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
