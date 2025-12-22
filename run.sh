#!/usr/bin/env bash
set -e

LOG_FILE="/config/files/lftp_worker.log"

FTP_HOST="${FTP_HOST}"
FTP_USER="${FTP_USER}"
FTP_PSW="${FTP_PSW}"

REMOTE_DIR="$1"
ACTION="$2"
LOCAL_DIR="$3"

echo "[$(date)] Avvio lftp worker - azione: ${ACTION}, dir remota: ${REMOTE_DIR}" >> "$LOG_FILE"

if [ -z "$REMOTE_DIR" ] || [ -z "$ACTION" ]; then
  echo "[$(date)] ERRORE: parametri mancanti" >> "$LOG_FILE"
  exit 1
fi

case "$ACTION" in
  clean_remote)
    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:list-options -a
cd /public/${REMOTE_DIR}
rm *
bye
EOF
    ;;
  
  upload_and_clean_local)
    if [ -z "$LOCAL_DIR" ]; then
      echo "[$(date)] ERRORE: LOCAL_DIR mancante" >> "$LOG_FILE"
      exit 1
    fi

    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:list-options -a
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

echo "[$(date)] Operazione completata con successo" >> "$LOG_FILE"
