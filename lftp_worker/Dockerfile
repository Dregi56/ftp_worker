ARG BUILD_FROM=ghcr.io/home-assistant/aarch64-base:latest
FROM ${BUILD_FROM}

ENV LANG C.UTF-8

# Dipendenze
RUN apk add --no-cache \
    lftp \
    bash \
    dos2unix

# Copia script principale
COPY run.sh /run.sh

# Permessi + conversione line endings
RUN dos2unix /run.sh && chmod +x /run.sh

# Comando di avvio
CMD [ "/run.sh" ]

