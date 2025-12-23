#!/usr/bin/with-contenv bashio

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

while read -r CMD; do
  bashio::log.info "Eseguo: $CMD"
  lftp -u "${USER},${PASS}" "${HOST}" -e "${CMD}; quit"
done
