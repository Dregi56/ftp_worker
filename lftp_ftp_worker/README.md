# LFTP FTP Worker Add-on

Questo add-on per Home Assistant è un **motore universale LFTP** progettato per gestire trasferimenti file tra l'istanza locale e un server FTP remoto in modo efficiente. A differenza di altri metodi, questo add-on rimane in ascolto e processa comandi complessi tramite lo standard input (`stdin`), permettendo di eseguire pulizie, upload e download in un'unica sessione senza riconnessioni multiple.

## Caratteristiche
* **Motore LFTP**: Supporta operazioni avanzate, modalità passiva e gestione robusta degli errori.
* **Comandi Dinamici**: Non è limitato a una funzione fissa; accetta qualsiasi comando LFTP tramite automazioni.
* **Sicurezza**: Le credenziali FTP sono salvate in modo sicuro nella configurazione dell'add-on.

---

## Installazione

1.  Copia l'URL della tua repository GitHub.
2.  In Home Assistant, vai in **Impostazioni** > **Add-on** > **Raccolta di Add-on**.
3.  Clicca sui tre puntini in alto a destra e seleziona **Repository**.
4.  Incolla l'URL e clicca su **Aggiungi**.
5.  Cerca "LFTP FTP Worker" nella lista, cliccaci sopra e premi **Installa**.

---

## Configurazione

Una volta installato, vai nella scheda **Configurazione** e compila i seguenti campi:

* `ftp_host`: L'indirizzo del tuo server FTP (es: `ftp.miosito.it`).
* `ftp_user`: Il tuo nome utente FTP.
* `ftp_psw`: La tua password FTP.

**Nota:** Assicurati di attivare l'opzione "Watchdog" se vuoi che l'add-on sia sempre attivo e pronto a ricevere comandi.

---

## Utilizzo tramite Automazioni

L'add-on non esegue nulla all'avvio, ma resta in attesa. Per inviare comandi, usa il servizio `hassio.addon_stdin`.

### Esempio: Manutenzione Settimanale
Questa automazione pulisce le cartelle remote, carica i nuovi file `.mp4` e chiude la connessione.

```yaml
alias: "Sincronizzazione Settimanale FTP"
trigger:
  - platform: time
    at: "03:00:00"
    昼: mon
action:
  # Avvia l'add-on se non è già attivo
  - service: hassio.addon_start
    data:
      addon: lftp_ftp_worker

  # Invia i comandi LFTP
  - service: hassio.addon_stdin
    data:
      addon: lftp_ftp_worker
      input: >
        cd /public/da_sud; rm -rf *; mput /share/da_sud/*.mp4;
        cd /public/est_piazzola; rm -rf *; mput /share/est_piazzola/*.mp4;
        cd /public/est_cortile; rm -rf *; mput /share/est_cortile/*.mp4

  # Pulizia locale tramite shell_command (opzionale)
  - service: shell_command.pulisci_registrazioni_locali
