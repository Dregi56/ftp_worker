ARG BUILD_FROM
FROM $BUILD_FROM

# Installa lftp e bash
RUN apk add --no-cache lftp bash

# Copia lo script nella root e rendilo eseguibile
COPY run.sh /
RUN chmod a+x /run.sh

# Rimuovi la copia del file lftp_script.lftp se non esiste fisicamente su GitHub
# COPY lftp_script.lftp /lftp_script.lftp 

CMD [ "/run.sh" ]
