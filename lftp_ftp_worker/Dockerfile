ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione dei pacchetti necessari (lftp e bash)
RUN apk add --no-cache lftp bash

# Copia lo script run.sh dal tuo repository GitHub alla radice del container
COPY run.sh /run.sh

# Rendi lo script eseguibile (permessi Linux)
RUN chmod a+x /run.sh

# Comando di avvio: forza l'uso di bash per caricare il file
ENTRYPOINT [ "/bin/bash", "/run.sh" ]
