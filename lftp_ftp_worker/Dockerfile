ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti
RUN apk add --no-cache lftp bash dos2unix

# Copia e pulizia script
COPY run.sh /run.sh
RUN dos2unix /run.sh && chmod a+x /run.sh

# Avvio tramite l'ambiente S6 di Home Assistant
CMD [ "/run.sh" ]
