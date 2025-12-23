#!/usr/bin/with-conten-env bashio

# Recupera le credenziali dalla configurazione dell'add-on
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "--- MOTORE LFTP AVVIATO ---"
bashio::log.info "Connesso all'host: ${HOST}"

# Resta in attesa di comandi tramite stdin (Standard Input)
while read -r input; do
    bashio::log.info "Esecuzione comando: $input"
    # Esegue il comando su LFTP e poi chiude la sessione per quel comando
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
