#!/usr/bin/with-contenv bashio
# 1. Creiamo il file di configurazione per ignorare i certificati a monte
# Questo evita di dover scrivere "set ssl..." ogni volta nell'automazione
echo "set ssl:verify-certificate no" > ~/.lftprc
echo "set ssl:check-hostname no" >> ~/.lftprc

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

while read -r CMD; do
  bashio::log.info "Eseguo: $CMD"
  lftp -u "${USER},${PASS}" "${HOST}" -e "${CMD}; quit"
done
