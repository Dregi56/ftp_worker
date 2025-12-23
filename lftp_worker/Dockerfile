ARG BUILD_FROM
FROM $BUILD_FROM

# Installazione pacchetti
RUN apk add --no-cache lftp bash dos2unix

# Copia il file run.sh dal tuo GitHub dentro l'add-on
COPY run.sh /
RUN chmod a+x /run.sh && dos2unix /run.sh

CMD [ "/run.sh" ]
