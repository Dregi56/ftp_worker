# ftp_worker
Crea un collegamento FTP per azioni su server remoto

# LFTP FTP Worker

Add-on per Home Assistant (Hass.io) per trasferimenti FTP persistenti tramite **lftp**. Permette di caricare file (es. video dalle telecamere) su un server FTP remoto e di pulire file locali o remoti automaticamente. Funzionalità principali: upload dei file locali su un server FTP remoto, pulizia dei file locali dopo l’upload, pulizia della directory remota prima dell’upload, logging delle operazioni in `/config/files/lftp_worker.log`, compatibile con più telecamere e directory diverse, sicuro: le credenziali FTP non sono incluse nei file, vanno configurate tramite `options` o `secrets.yaml`.

## Struttura dei file

```
lftp_ftp_worker/
├─ Dockerfile
├─ config.yaml
├─ run.sh
├─ lftp_script.lftp (opzionale)
└─ README.md
```

## Configurazione (`config.yaml`)

```yaml
name: LFTP FTP Worker
version: "1.0.0"
slug: lftp_ftp_worker
description: Add-on per trasferimenti FTP persistenti tramite lftp
startup: application
boot: auto
arch:
  - aarch64
  - armv7
  - armhf
  - amd64
init: false
options:
  ftp_host: ""
  ftp_user: ""
  ftp_psw: ""
schema:
  ftp_host: str
  ftp_user: str
  ftp_psw: password
```

> Inserisci `ftp_host`, `ftp_user`, `ftp_psw` con le credenziali del server remoto.  
> Non inserire le credenziali reali nel repository pubblico: usa placeholder o `secrets.yaml`.

## Uso dello script (`run.sh`)

```
/run.sh REMOTE_DIR ACTION LOCAL_DIR
```

- `REMOTE_DIR` → directory remota sul server FTP  
- `ACTION` → azione da eseguire:  
  - `clean_remote` → pulisce la directory remota  
  - `upload_and_clean_local` → carica i file locali e li cancella  
- `LOCAL_DIR` → percorso locale dei file da caricare (solo per `upload_and_clean_local`)

### Esempi

Pulizia della directory remota:

```
/run.sh da_sud clean_remote
```

Upload dei file di una telecamera e pulizia locale:

```
/run.sh est_cortile upload_and_clean_local /media/camera_est_cortile
```

## Log

Tutte le operazioni vengono registrate in:

```
/config/files/lftp_worker.log
```

## Sicurezza

- Le credenziali FTP non devono mai essere inserite nel repository pubblico.  
- Usare sempre `secrets.yaml` o `options` dell’add-on per configurare host, utente e password.

## Installazione come add-on locale

1. Carica la cartella `lftp_ftp_worker` su un repository GitHub (pubblico o privato)  
2. In Hass.io / Supervisor → Add-on Store → Repositories, aggiungi l’URL del repository  
3. Dopo aggiornamento, il tuo add-on comparirà nell’Add-on Store → installalo  
4. Configura le credenziali FTP e avvia l’add-on

## Collegamento con automazioni

Esempio `shell_command` in Home Assistant:

```yaml
shell_command:
  upload_video: >
    docker exec addon_lftp_ftp_worker /run.sh est_cortile upload_and_clean_local /media/camera_est_cortile
```

Può essere richiamato dalle automazioni per trasferire automaticamente i file video delle telecamere.
