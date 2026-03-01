# 🚀 LFTP Worker Add-on for Home Assistant
---

## Autore
Realizzato da **Egidio Ziggiotto - Dregi56**<br>
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on).

![Version](https://img.shields.io/badge/version-1.2.21-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue?logo=home-assistant)
![Downloads](https://img.shields.io/github/downloads/Dregi56/ftp_worker/total)
![Stars](https://img.shields.io/github/github-stars/Dregi56/ftp_worker?style=flat)
![Latest Release](https://img.shields.io/github/v/release/Dregi56/ftp_worker)


🌍 **Languages:**  
[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇵🇹 Português](README.pt.md) | [🇫🇷 Français](README.fr.md)

## Informazioni sul Progetto
**Data ultimo aggiornamento:** ![GitHub last commit](https://img.shields.io/github/last-commit/Dregi56/ftp_worker?label=%20)  
🏷️ **Versione corrente:** ![GitHub release (latest by date)](https://img.shields.io/github/v/release/Dregi56/ftp_worker?label=%20) "Universal Edition"

## Registro delle Modifiche
- **v1.2.21 (08/01/2026):** Modifiche per interattività al log di registro dell'add-on
- **v1.2.7 (27/12/2025):** Configurato FIFO per output nel registro dell'add-on
- **v1.2.4 (24/12/2025):** Aggiunti verbose no per per tenere pulito il registro.
- **v1.2.3 (24/12/2025):** Rinominato l' add-on in LFTP Worker e inserita e-mail autore.
- **v1.2.0 (24/12/2025):** Possibilità di configurare un mirror tra due directory, locale e remota, una tantum all'avvio o a tempo.
- **v1.1.6 (24/12/2025):** Esegui all'avvio settato off. Aggiunti qui esempi di comandi lfpt.
- **v1.1.5 (24/12/2025):** Cambiato nome all' add-on. Corrette alcune voci restituite nel registro.
- **v1.1.4 (24/12/2025):** Corretto il bug causato dal fallimento del loggin al server remoto.
- **v1.1.3 (23/12/2025):** Avvio valido!
- **v1.0.7 (23/12/2025):** Correzione bug directory.
- **v1.0.6 (23/12/2025):** Correzione bug run.sh
- **v1.0.5 (23/12/2025):** Trasformazione in motore universale tramite `stdin`. Aggiunta gestione dinamica dei comandi lftp.
- **v1.0.0:** Versione iniziale del worker FTP.

---

## 📌 Installation

### 🏠 Quick Install (Recommended)

Add this repository directly to your Home Assistant instance:

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/Dregi56/ftp_worker)

---

### 🔧 Manual Installation

1. Copy your GitHub repository URL.  
2. In Home Assistant, go to **Settings** > **Add-ons** > **Add-on Store**.  
3. Click the three dots in the top right corner and select **Repositories**.  
4. Paste the repository URL (`https://github.com/Dregi56/ftp_worker`) and click **Add**.  
5. Search for **"LFTP FTP Worker"**, click on it, and press **Install**.  

📝 Descrizione
Questo add-on per Home Assistant è un **motore universale LFTP** progettato per gestire trasferimenti file tra l'istanza locale e un server FTP remoto in modo efficiente. A differenza di altri metodi, questo add-on rimane in ascolto e processa comandi complessi tramite lo standard input (`stdin`), permettendo di eseguire pulizie, upload e download in un'unica sessione senza riconnessioni multiple. 
E' però possibile porre l'add-on in mirroring tra due cartelle, anche filtrando i file che si vogliono mantenere aggiornati.

✨ Caratteristiche
* **Motore LFTP**: Supporta operazioni avanzate, modalità passiva e gestione robusta degli errori.
* **Comandi Dinamici**: Non è limitato a una funzione fissa; accetta qualsiasi comando LFTP tramite automazioni.
* **Mirroring**: In opzioni si possono stabilire due cartelle da tenere aggiornate
* **Sicurezza**: Le credenziali FTP sono salvate in modo sicuro nella configurazione dell'add-on.

---
---

📌 Configurazione

Una volta installato, vai nella scheda **Configurazione** e compila i seguenti campi:

* `host`: L'indirizzo del tuo server FTP (es: `ftp.miosito.it`).
* `user`: Il tuo nome utente FTP.
* `psw`: La tua password FTP.

Opzionali per sincronismo:
* `local_dir`: Cartella locale.
* `remote_dir`: Cartella remota.
* `interval`: Espresso in secondi
* `extensions`: es. txt, mp4

  🔹 **Nota:** Di default la voce **Esegui all'avvio** è off in quanto è inutile e dispendioso in termini di risorse mantenere apperto un collegamento col server remoto.
               Se si sta utilizzando l'add-on per sincronismo è opportuno settarlo on.
---

🎯 Utilizzo tramite Automazioni

Per questo utilizzo in Configurazione lasciare vuoti gli input per dir_locale e dir_remota e interval
L'add-on non esegue nulla all'avvio, ma resta in attesa. Per inviare comandi, usa il servizio `hassio.addon_stdin`.
<br>⚠️ **NOTA IMPORTANTE**: E' possibile eseguire **una sola riga di comando per volta**. Ma è possibile concatenare comandi separandoli tra loro con 'punto e virgola'


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
        input: "set cmd:verbose yes; cd /public/da_sud; rm -rf *; mput /media/da_sud/*.mp4"
    # 3. Attesa dopo fine trasferimento 
    - delay: "00:05:00"
    # 4. Pulizia locale
    - service: shell_command.pulisci_locale_da_sud
    - service: shell_command.pulisci_locale_est_piazzola
    # 5. Arresta il collegamento
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: quit
    # 6. Stop add-on
    - service: hassio.addon_stop
      data:
        addon: "6d4a8c9b_lftp_worker"
  mode: single
```
---

🎯 Utilizzo per sincronismo

Per questo utilizzo impostare  gli input per `dir_locale` e `dir_remota` e `interval` nella sezione `Configurazione`
E' possibile mantenere un sincronismo costante tra due cartelle, una locale ed una remota, impostando il nome delle cartelle stesse in configurazione add-on.
Se non viene impostato `interval` l'esecuzione di sincronismo avviene una tantum all'avvio dell'add-on, avvio che può essere richiamato dall'interno di una automazione.
Lasciando vuoto `extension`, tutti i file della cartella veranno sincronizzati, diversamente solo quelli con l'estensione indicata.
Può essere indicata più di una tipologia di file es. txt, mp4, doc
Per questo utilizzo può essere utile impostare `Esegui all'avvio` e `Watchdog` su on

---

📁 **COMANDI DI TRASFERIMENTO BASE**
---------------------------------
- 🔹 `get <file>`     → Scarica **un file remoto**
- 🔹 `mget <pattern>` → Scarica **più file** che corrispondono al pattern (es. `*.mp4`)
- 🔹 `put <file>`     → Carica **un file locale**
- 🔹 `mput <pattern>` → Carica **più file** da locale a remoto

🔄 **COMANDI DI SINCRONIZZAZIONE**
---------------------------------
- 🔹 `mirror <remote> <local>`          → Sincronizza directory **remota → locale**
- 🔹 `mirror -c <remote> <local>`       → Sincronizza **solo nuovi file**
- 🔹 `mirror --reverse <local> <remote>` → Sincronizza **locale → remoto** (upload)

📌 **COMANDI UTILI PER FILE REMOTI**
---------------------------------
- 🔹 `mkdir <dir>`    → Crea directory remota
- 🔹 `rm <file>`      → Cancella file remoto
- 🔹 `mrm <pattern>`  → Cancella più file remoto (con wildcard)
- 🔹 `mv <src> <dst>` → Rinomina o sposta un file remoto
<br>     ⚠️ **NOTA IMPORTANTE**
         Tutti questi comandi non danno alcun riscontro nel file registro dell'add-on!
  
🛠️ **COMANDI DI CONTROLLO**
---------------------------------
- 🔹 `quit` o `exit`  → Chiude la sessione `lftp`

## 

## ☕ Supporta il progetto

Ti piace questo progetto? Se lo trovi utile, offrimi un caffè virtuale per sostenere le evoluzioni future! Ogni piccolo contributo è super apprezzato. 🙏

**LFT Worker è e rimarrà sempre gratuito e open source.** Le donazioni sono completamente volontarie! ❤️


[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Preferisci altri metodi?** Puoi usare:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)

  
