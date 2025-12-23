#!/usr/bin/with-conten-env bashio
set -e

# Recupero credenziali base
FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')
BASE_LOCAL="/share/ftp_upload"

# Questi parametri verranno passati dall'automazione o presi dal config
# Se passati come variabili d'ambiente da HA
SUB_DIR="${1:-$(bashio::config 'ftp_remote_dir')}"

bashio::log.info "Connessione a $FTP_HOST per la cartella: $SUB_DIR"

lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
set ftp:list-options -a

# 1. Entra nella directory remota
cd /public/${SUB_DIR}

# 2. PULIZIA: Rimuove tutti i file esistenti (.mp4 e altro)
bashio::log.info "Pulizia directory remota /public/${SUB_DIR}..."
rm -rf *

# 3. UPLOAD: Trasferisce i nuovi file .mp4
bashio::log.info "Trasferimento file .mp4 da locale..."
mput ${BASE_LOCAL}/${SUB_DIR}/*.mp4

# 4. CHIUSURA
bye
EOF

bashio::log.info "Operazione completata per $SUB_DIR. Scollegato."
