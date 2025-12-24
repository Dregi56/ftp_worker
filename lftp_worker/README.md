# LFTP Worker Add-on
---

## Autore
Realizzato da **Egidio Ziggiotto - Dregi56** .
## Licenza
Questo progetto è rilasciato sotto licenza MIT. Sei libero di usarlo, modificarlo e distribuirlo, a patto di citare l'autore originale.

## Informazioni sul Progetto
**Data Ultimo Aggiornamento:** 23 Dicembre 2025
* **Versione Corrente:** 1.1.5 "Universal Edition"

## Registro delle Modifiche
- **v1.1.5 (24/12/2025):** Cambiato nome all' add-on. Corrette alcune voci restituite nel registro
- **v1.1.4 (24/12/2025):** Corretto il bug causato dal fallimento del loggin al server remoto
- **v1.1.3 (23/12/2025):** Avvio valido!
- **v1.0.7 (23/12/2025):** Correzione bug directory
- **v1.0.6 (23/12/2025):** Correzione bug run.sh
- **v1.0.5 (23/12/2025):** Trasformazione in motore universale tramite `stdin`. Aggiunta gestione dinamica dei comandi lftp.
- **v1.0.0:** Versione iniziale del worker FTP.

Questo add-on per Home Assistant è un **motore universale LFTP** progettato per gestire trasferimenti file tra l'istanza locale e un server FTP remoto in modo efficiente. A differenza di altri metodi, questo add-on rimane in ascolto e processa comandi complessi tramite lo standard input (`stdin`), permettendo di eseguire pulizie, upload e download in un'unica sessione senza riconnessioni multiple.

## Caratteristiche
* **Motore LFTP**: Supporta operazioni avanzate, modalità passiva e gestione robusta degli errori.
* **Comandi Dinamici**: Non è limitato a una funzione fissa; accetta qualsiasi comando LFTP tramite automazioni.
* **Sicurezza**: Le credenziali FTP sono salvate in modo sicuro nella configurazione dell'add-on.

---

## Installazione

1.  Copia l'URL della tua repository GitHub.
2.  In Home Assistant, vai in **Impostazioni** > **Add-on** > **Raccolta di Add-on**.
3.  Clicca sui tre puntini in alto a destra e seleziona **Archivi digitali**.
4.  Incolla l'URL del repository (https://github.com/Dregi56/ftp_worker) clicca su **Aggiungi**.
5.  Cerca "LFTP FTP Worker" nella lista degli add-on disponibili, cliccaci sopra e premi **Installa**.

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
Questa automazione avvia l'add-on, pulisce le cartelle remote, carica i nuovi file `.mp4` chiude la connessione e pulisce le cartelle locali, spegne l'add-on.

```yaml
- id: weekly_ftp_sync
  alias: "Manutenzione Settimanale Video FTP"
  description: "Pulisce remoto, carica nuovi MP4 e svuota locale ogni lunedì notte"
  trigger:
    - platform: time
      at: "03:00:00"
  condition:
    - condition: time
      weekday:
        - mon
  action:
    # 1. Avvio add-on
    - service: hassio.addon_start
      data:
        addon: "6d4a8c9b_lftp_worker"
    - delay: "00:00:20"   # tempo di boot add-on
    # 2. Invio comandi lftp (SESSIONE UNICA)
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: |
          set cmd:verbose yes
          cd /public/da_sud
          rm -rf *
          mput /media/da_sud/*.mp4

          cd /public/est_piazzola
          rm -rf *
          mput /media/est_piazzola/*.mp4
          quit
    # 3. Attesa dopo fine trasferimento 
    - delay: "00:05:00"
    # 4. Pulizia locale
    - service: shell_command.pulisci_locale_da_sud
    - service: shell_command.pulisci_locale_est_piazzola
    # 5. Stop add-on
    - service: hassio.addon_stop
      data:
        addon: "6d4a8c9b_lftp_worker"
  mode: single
