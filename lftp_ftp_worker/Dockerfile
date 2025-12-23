ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache lftp bash dos2unix

COPY run.sh /run.sh
RUN dos2unix /run.sh && chmod a+x /run.sh

CMD [ "/run.sh" ]
