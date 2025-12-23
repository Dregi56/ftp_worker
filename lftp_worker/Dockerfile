ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti e pulizia caratteri
RUN apk add --no-cache lftp bash dos2unix

# Creiamo il file run.sh riga per riga direttamente qui
RUN echo '#!/usr/bin/with-conten-env bashio' > /run.sh \
    && echo 'bashio::log.info "--- MOTORE LFTP AVVIATO (v1.0.20) ---"' >> /run.sh \
    && echo 'HOST=$(bashio::config "host")' >> /run.sh \
    && echo 'USER=$(bashio::config "username")' >> /run.sh \
    && echo 'PASS=$(bashio::config "password")' >> /run.sh \
    && echo 'bashio::log.info "Connesso a: ${HOST}"' >> /run.sh \
    && echo 'while read -r input; do' >> /run.sh \
    && echo '  bashio::log.info "Eseguo: $input"' >> /run.sh \
    && echo '  lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"' >> /run.sh \
    && echo 'done' >> /run.sh

# Rendiamo il file eseguibile e forziamo il formato Unix
RUN chmod +x /run.sh && dos2unix /run.sh

# Comandiamo ad HA di usare questo file
CMD [ "/run.sh" ]
