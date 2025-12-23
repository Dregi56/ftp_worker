ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti
RUN apk add --no-cache lftp bash dos2unix

# Copia lo script di avvio
COPY run.sh /
RUN chmod a+x /run.sh && dos2unix /run.sh

CMD [ "/run.sh" ]
