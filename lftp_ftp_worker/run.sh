#!/usr/bin/with-conten-env bashio
set -e

FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')
REMOTE_DIR=$(bashio::config 'ftp_remote_dir')
ACTION=$(bashio::config 'ftp_action')
LOCAL_DIR=$(bashio::config 'ftp_local_dir')

LOG_FILE="/config/lftp_worker.log"

{
echo "[$(date)] --- NUOVA SESSIONE ---"
echo "[$(date)] Azione: ${ACTION}"

if [ -z "$REMOTE_DIR" ] || [ -z "$ACTION" ]; then
    echo "[$(date)] ERRORE: parametri mancanti nella configurazione"
    exit 1
fi

case "$ACTION" in
    clean_remote)
        lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
rm -r *
bye
EOF
        ;;
    upload_and_clean_local)
        lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
mput ${LOCAL_DIR}/*
bye
EOF
        rm -f ${LOCAL_DIR}/*
        ;;
    *)
        echo "[$(date)] ERRORE: azione sconosciuta: $ACTION"
        exit 1
        ;;
esac

echo "[$(date)] Operazione completata"
} | tee -a "$LOG_FILE"
