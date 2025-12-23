ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti
RUN apk add --no-cache lftp bash dos2unix

# Creazione del file run.sh con un unico comando per evitare errori di concatenazione
RUN printf '#!/usr/bin/with-conten-env bashio\n\
HOST=$(bashio::config "host")\n\
USER=$(bashio::config "username")\n\
PASS=$(bashio::config "password")\n\
bashio::log.info "--- MOTORE LFTP AVVIATO (v1.0.16) ---"\n\
bashio::log.info "Connesso a: ${HOST}"\n\
while read -r input; do\n\
  bashio::log.info "Eseguo: $input"\n\
  lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"\n\
done' > /run.sh

# Permessi totali e pulizia caratteri Windows
RUN chmod 777 /run.sh && dos2unix /run.sh

# Punto di ingresso esplicito
ENTRYPOINT [ "/run.sh" ]
