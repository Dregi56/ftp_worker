ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti
RUN apk add --no-cache lftp bash dos2unix

# CREAZIONE DIRETTA DEL FILE RUN.SH
RUN echo '#!/usr/bin/with-conten-env bashio' > /run.sh \
    && echo 'HOST=$(bashio::config "host")' >> /run.sh \
    && echo 'USER=$(bashio::config "username")' >> /run.sh \
    && echo 'PASS=$(bashio::config "password")' >> /run.sh \
    && echo 'bashio::log.info "--- MOTORE LFTP AVVIATO (v1.1.7) ---"' >> /run.sh \
    && echo 'bashio::log.info "Connesso a: ${HOST}"' >> /run.sh \
    && echo 'while read -r input; do' >> /run.sh \
    && echo '  bashio::log.info "Eseguo: $input"' >> /run.sh \
    && echo '  lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"' >> /run.sh \
    && echo 'done' >> /run.sh

# Permessi obbligatori
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
