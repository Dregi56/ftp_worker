#!/usr/bin/with-contenv bashio

# -------------------------------
# Configurazione lftp
# -------------------------------
cat <<EOF > ~/.lftprc
set ssl:verify-certificate no
set ssl:check-hostname no
set ftp:passive-mode on
set ftp:ssl-allow yes
set xfer:clobber on
set net:timeout 10
set net:max-retries 2
EOF

bashio::log.info "--- MOTORE LFTP AVVIATO (SESSIONE PERSISTENTE) ---"

HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

bashio::log.info "Connesso FTP a ${HOST}"
bashio::log.info "In attesa di comandi..."

# Avvia lftp in modalità interattiva
# stdin dell'add-on -> stdin di lftp
exec lftp -u "${USER},${PASS}" "${HOST}"
