ARG BUILD_FROM
FROM $BUILD_FROM

# Installa lftp
RUN apk add --no-cache lftp bash

# Copia script
COPY run.sh /run.sh

# Permessi
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
