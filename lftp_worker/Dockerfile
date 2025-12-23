ARG BUILD_FROM
FROM $BUILD_FROM

WORKDIR /

RUN apk add --no-cache lftp bash dos2unix

COPY run.sh /run.sh

RUN chmod +x /run.sh \
    && dos2unix /run.sh
