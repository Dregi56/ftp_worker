#!/usr/bin/with-conten-env bashio

# Recupero credenziali base
FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')

bashio::log.info "Motore LFTP avviato. In attesa di comandi tramite stdin..."

# Resta in ascolto infinito dei comandi inviati da Home Assistant
while read -r input; do
    bashio::log.info "Esecuzione comando ricevuto: $input"
    
    # Esegue lftp con il comando esatto che gli hai passato
    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
    set ftp:passive-mode on
    set ftp:ssl-allow no
    $input
    bye
EOF

    bashio::log.info "Comando completato."
done
