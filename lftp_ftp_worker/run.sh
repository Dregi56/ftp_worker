#!/usr/bin/with-conten-env bashio

# 1. Recupero credenziali dalla configurazione dell'add-on
FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')

bashio::log.info "Motore LFTP Universale avviato."
bashio::log.info "In attesa di comandi tramite stdin (Standard Input)..."

# 2. Ciclo infinito: resta in ascolto dei comandi inviati da HA
while read -r input; do
    # Verifica che l'input non sia vuoto
    if [ ! -z "$input" ]; then
        bashio::log.info "Ricevuto comando: $input"
        
        # Esecuzione del comando tramite lftp
        lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
        set ftp:passive-mode on
        set ftp:ssl-allow no
        $input
        bye
EOF
        
        if [ $? -eq 0 ]; then
            bashio::log.info "Comando eseguito con successo."
        else
            bashio::log.error "Errore durante l'esecuzione del comando."
        fi
    fi
done
