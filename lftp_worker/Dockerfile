ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti necessari
RUN apk add --no-cache lftp bash dos2unix

# Creazione del file run.sh direttamente nel Dockerfile
RUN printf '#!/usr/bin/with-conten-env bashio\n\
HOST=$(bashio::config "host")\n\
USER=$(bashio::config "username")\n\
PASS=$(bashio::config "password")\n\
bashio::log.info "--- MOTORE LFTP AVVIATO (v1.0.17) ---"\n\
bashio::log.info "Connesso a: ${HOST}"\n\
while read -r input; do\n\
  bashio::log.info "Eseguo comando: $input"\n\
  lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"\n\
done' > /run.sh

# Permessi e correzione formato file per Linux
RUN chmod +x /run.sh && dos2unix /run.sh

CMD [ "/run.sh" ]
