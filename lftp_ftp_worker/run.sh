#!/usr/bin/with-conten-env bashio
set -e

FTP_HOST=$(bashio::config 'ftp_host')
FTP_USER=$(bashio::config 'ftp_user')
FTP_PSW=$(bashio::config 'ftp_psw')
LOCAL_ROOT=$(bashio::config 'ftp_local_dir') # Es: /share/telecamere

bashio::log.info "Avvio Sincronizzazione Settimanale FTP..."

# Elenco delle tue cartelle
DIRECTORIES=("da_sud" "est_piazzola" "est_cortile")

for DIR in "${DIRECTORIES[@]}"; do
    bashio::log.info "Elaborazione cartella: $DIR"
    
    lftp -u "$FTP_USER","$FTP_PSW" "$FTP_HOST" <<EOF
set ftp:passive-mode on
set ftp:ssl-allow no
# 1. Entra nella cartella remota (creandola se serve)
mkdir -p /public/$DIR
cd /public/$DIR
# 2. Pulisce i file della settimana precedente sul server
bashio::log.info "Svuoto remoto: /public/$DIR"
rm -rf *
# 3. Carica i file mp4 della settimana corrente
bashio::log.info "Carico nuovi file da $LOCAL_ROOT/$DIR"
mput $LOCAL_ROOT/$DIR/*.mp4
bye
EOF

    # 4. Pulisce il locale per la nuova settimana
    bashio::log.info "Svuoto locale: $LOCAL_ROOT/$DIR"
    rm -f $LOCAL_ROOT/$DIR/*.mp4
done

bashio::log.info "Manutenzione settimanale completata con successo!"
