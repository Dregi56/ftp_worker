#!/usr/bin/with-conten-env bashio
set -e

# Recupera le opzioni dal config.yaml tramite bashio
FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')

# Percorso log (assicurati che la cartella /config/ sia scrivibile)
LOG_FILE="/config/lftp_worker.log"

# Nota: REMOTE_DIR, ACTION e LOCAL_DIR dovrebbero essere passati come argomenti
# o recuperati anch'essi dal config se sono fissi.
REMOTE_DIR=$1
ACTION=$2
LOCAL_DIR=$3

echo "[$(date)] Avvio lftp worker - azione: ${ACTION}" >> "$LOG_FILE"

if [ -z "$REMOTE_DIR" ] || [ -z "$ACTION" ]; then
  echo "[$(date)] ERRORE: parametri mancanti (REMOTE_DIR o ACTION)" >> "$LOG_FILE"
  exit 1
fi

case "$ACTION" in
  clean_remote)
    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
rm -r *
bye
EOF
    ;;
  
  upload_and_clean_local)
    if [ -z "$LOCAL_DIR" ]; then
      echo "[$(date)] ERRORE: LOCAL_DIR mancante" >> "$LOG_FILE"
      exit 1
    fi
    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:ssl-allow no
cd /public/${REMOTE_DIR}
mput ${LOCAL_DIR}/*
bye
EOF
    rm -f ${LOCAL_DIR}/*
    ;;
  
  *)
    echo "[$(date)] ERRORE: azione sconosciuta: $ACTION" >> "$LOG_FILE"
    exit 1
    ;;
esac

echo "[$(date)] Operazione completata" >> "$LOG_FILE"
