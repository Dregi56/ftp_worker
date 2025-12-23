ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti necessari
RUN apk add --no-cache lftp bash dos2unix

# Copia TUTTI i file dalla cartella dell'add-on nel contenitore
COPY . /
# Forza la pulizia del file run.sh e dai i permessi
RUN dos2unix /run.sh && chmod a+x /run.sh

# Avvio
CMD [ "/run.sh" ]
