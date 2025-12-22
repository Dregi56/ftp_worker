ARG BUILD_FROM
FROM $BUILD_FROM

# Installa lftp
RUN apk add --no-cache lftp bash

# Copia script
COPY run.sh /run.sh
COPY lftp_script.lftp /lftp_script.lftp

# Permessi
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
