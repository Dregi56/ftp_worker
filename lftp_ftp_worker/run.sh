#!/usr/bin/env bash

# Carica configurazioni
HOST=$(bashio::config 'host')
USER=$(bashio::config 'username')
PASS=$(bashio::config 'password')

echo "--- TEST AVVIO ---"
echo "Provo a connettermi a: ${HOST}"

# Motore in ascolto
while read -r input; do
    echo "Esecuzione comando: $input"
    lftp -u "${USER},${PASS}" "${HOST}" -e "${input}; quit"
done
