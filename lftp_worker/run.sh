#!/usr/bin/with-contenv bashio

# 1. Configurazione per Aruba (Usiamo il tuo metodo echo)
echo "set ssl:verify-certificate no" > ~/.lftprc
echo "set ssl:check-hostname no" >> ~/.lftprc
echo "set ftp:passive-mode on" >> ~/.lftprc
echo "set ftp:ssl-allow yes" >> ~/.lftprc

bashio::log.info "--- MOTORE LFTP AVVIATO ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

while read -r CMD; do
  if [ ! -z "$CMD" ]; then
    bashio::log.info "Eseguo: $CMD"
    lftp -u "${USER}"','"${PASS}" "${HOST}" -e "${CMD}; quit"
  fi
done
