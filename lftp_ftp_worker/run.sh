#!/usr/bin/with-conten-env bashio
set -e

# 1. Recupera le opzioni dal config.yaml tramite bashio
FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')
REMOTE_DIR=$(bashio::config 'ftp_remote_dir')
ACTION=$(bashio::config 'ftp_action')
LOCAL_DIR=$(bashio::config 'ftp_local_dir')

LOG_FILE="/config/lftp_worker.log"

# 2. Messaggio iniziale nel Registro di Home Assistant
bashio::log.info "Avvio LFTP Worker..."
bashio::log.info "Configurazione: Azione=${ACTION} su Host=${FTP_HOST}"

# Controllo parametri
if [ -z "$REMOTE_DIR" ] || [ -z "$ACTION" ]; then
    bashio::log.error "Parametri mancanti nella configurazione! Verifica REMOTE_DIR e ACTION."
    exit 1
fi

# 3. Esecuzione Azioni
case "$ACTION" in
    clean_remote)
        bashio::log.info "Pulizia della cartella remota: /public/${REMOTE_DIR}"
        lftp -u "$FTP_USER","$FTP_PSW" "$HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
rm -r *
bye
EOF
        ;;

    upload_and_clean_local)
        if [ -z "$LOCAL_DIR" ]; then
            bashio::log.error "LOCAL_DIR non configurata!"
            exit 1
        fi
        bashio::log.info "Caricamento file da ${LOCAL_DIR} a /public/${REMOTE_DIR}"
        
        lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
mput ${LOCAL_DIR}/*
bye
EOF
        
        bashio::log.info "Pulizia file locali in ${LOCAL_DIR}"
        rm -f ${LOCAL_DIR}/*
        ;;

    *)
        bashio::log.error "Azione sconosciuta: $ACTION"
        exit 1
        ;;
esac

bashio::log.info "Operazione completata con successo."
echo "[$(date)] Operazione completata: ${ACTION}" >> "$LOG_FILE"
