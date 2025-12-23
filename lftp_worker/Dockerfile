ARG BUILD_FROM
FROM $BUILD_FROM

WORKDIR /

RUN apk add --no-cache lftp bash dos2unix

# COPIA ESPLICITA E SICURA
COPY ./run.sh /run.sh

RUN chmod 755 /run.sh \
    && dos2unix /run.sh
