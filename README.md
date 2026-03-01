# 🚀 LFTP Worker Add-on for Home Assistant
---

## Author
Created by **Egidio Ziggiotto - Dregi56**<br>
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on).

![Vesion](https://img.shields.io/github/v/release/Dregi56/ftp_worker?color=orange&label=latest%20version)
![License](https://img.shields.io/badge/license-MIT-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue?logo=home-assistant)
![Downloads](https://img.shields.io/github/downloads/Dregi56/ftp_worker/total?color=blue&label=downloads)
![Stars](https://img.shields.io/github/stars/Dregi56/ftp_worker?style=social)


🌍 **Languages:**  
[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇵🇹 Português](README.pt.md) | [🇫🇷 Français](README.fr.md)

## Project Information
**Last Updated:** ![GitHub last commit](https://img.shields.io/github/last-commit/Dregi56/ftp_worker?label=%20)  
🏷️ **Current Version:** ![GitHub release (latest by date)](https://img.shields.io/github/v/release/Dregi56/ftp_worker?label=%20) "Universal Edition"

## Changelog
- **v1.2.21 (01/08/2026):** Changes for improved interactivity in the add-on log.
- **v1.2.7 (12/27/2025):** Configured FIFO for output in the add-on log.
- **v1.2.4 (12/24/2025):** Added `verbose no` to keep the log clean.
- **v1.2.3 (12/24/2025):** Renamed the add-on to LFTP Worker and added the author email.
- **v1.2.0 (12/24/2025):** Possibility to configure mirroring between two directories, local and remote, either once at startup or scheduled.
- **v1.1.6 (12/24/2025):** Set "Start on boot" to off. Added LFTP command examples here.
- **v1.1.5 (12/24/2025):** Changed the add-on name. Corrected some log output entries.
- **v1.1.4 (12/24/2025):** Fixed the bug caused by remote server login failure.
- **v1.1.3 (12/23/2025):** Valid startup!
- **v1.0.7 (12/23/2025):** Directory bug fix.
- **v1.0.6 (12/23/2025):** run.sh bug fix.
- **v1.0.5 (12/23/2025):** Transformation into a universal engine via `stdin`. Added dynamic management of LFTP commands.
- **v1.0.0:** Initial FTP worker version.

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

📝 Description  
This Home Assistant add-on is a **universal LFTP engine** designed to efficiently manage file transfers between your local instance and a remote FTP server. Unlike other methods, this add-on stays listening and processes complex commands via standard input (`stdin`), allowing you to perform cleanups, uploads, and downloads in a single session without multiple reconnections.  
It is also possible to configure the add-on in mirroring mode between two folders, optionally filtering which files you want to keep updated.

✨ Features  
* **LFTP Engine**: Supports advanced operations, passive mode, and robust error handling.
* **Dynamic Commands**: Not limited to a fixed function; accepts any LFTP command via automations.
* **Mirroring**: In the options you can define two folders to keep synchronized.
* **Security**: FTP credentials are securely stored in the add-on configuration.

---
---

📌 Configuration

Once installed, go to the **Configuration** tab and fill in the following fields:

* `host`: Your FTP server address (e.g., `ftp.mysite.com`).
* `user`: Your FTP username.
* `psw`: Your FTP password.

Optional for synchronization:
* `local_dir`: Local folder.
* `remote_dir`: Remote folder.
* `interval`: Expressed in seconds.
* `extensions`: e.g., txt, mp4

  🔹 **Note:** By default, **Start on boot** is set to off because it is unnecessary and resource-intensive to keep an open connection to the remote server.  
               If you are using the add-on for synchronization, it is recommended to set it to on.

---

🎯 Usage via Automations

For this use case, leave the inputs for `local_dir`, `remote_dir`, and `interval` empty in the Configuration section.  
The add-on does nothing at startup but remains waiting. To send commands, use the `hassio.addon_stdin` service.  

<br>⚠️ **IMPORTANT NOTE**: It is possible to execute **only one command line at a time**. However, you can chain commands by separating them with a semicolon.

### Example: Weekly Maintenance
This automation starts the add-on, cleans remote folders, uploads new `.mp4` files, closes the connection, cleans local folders, and stops the add-on.

```yaml
- id: weekly_ftp_sync
  alias: "Weekly FTP Video Maintenance"
  description: "Cleans remote, uploads new MP4s, and empties local every Monday night"
  trigger:
    - platform: time
      at: "03:00:00"
  condition:
    - condition: time
      weekday:
        - mon
  action:
    # 1. Start add-on
    - service: hassio.addon_start
      data:
        addon: "6d4a8c9b_lftp_worker"
    - delay: "00:00:20"   # add-on boot time
    # 2. Send lftp commands (SINGLE SESSION)
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: "set cmd:verbose yes; cd /public/da_sud; rm -rf *; mput /media/da_sud/*.mp4"
    # 3. Wait after transfer completion 
    - delay: "00:05:00"
    # 4. Local cleanup
    - service: shell_command.pulisci_locale_da_sud
    - service: shell_command.pulisci_locale_est_piazzola
    # 5. Close the connection
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

🎯 Usage for Synchronization

For this use case, set the inputs for `local_dir`, `remote_dir`, and `interval` in the `Configuration` section.  
It is possible to maintain constant synchronization between two folders, one local and one remote, by setting their names in the add-on configuration.  
If `interval` is not set, synchronization will run once at add-on startup, which can be triggered from an automation.  
If `extensions` is left empty, all files in the folder will be synchronized; otherwise, only files with the specified extension will be synced.  
You can specify more than one file type, e.g., txt, mp4, doc.  
For this use case, it may be useful to set `Start on boot` and `Watchdog` to on.

---

📁 **BASIC TRANSFER COMMANDS**
---------------------------------
- 🔹 `get <file>`     → Download **a single remote file**
- 🔹 `mget <pattern>` → Download **multiple files** matching the pattern (e.g., `*.mp4`)
- 🔹 `put <file>`     → Upload **a single local file**
- 🔹 `mput <pattern>` → Upload **multiple files** from local to remote

🔄 **SYNCHRONIZATION COMMANDS**
---------------------------------
- 🔹 `mirror <remote> <local>`          → Synchronize directory **remote → local**
- 🔹 `mirror -c <remote> <local>`       → Synchronize **new files only**
- 🔹 `mirror --reverse <local> <remote>` → Synchronize **local → remote** (upload)

📌 **USEFUL REMOTE FILE COMMANDS**
---------------------------------
- 🔹 `mkdir <dir>`    → Create remote directory
- 🔹 `rm <file>`      → Delete remote file
- 🔹 `mrm <pattern>`  → Delete multiple remote files (with wildcard)
- 🔹 `mv <src> <dst>` → Rename or move a remote file
<br>     ⚠️ **IMPORTANT NOTE**
         All these commands do not provide any feedback in the add-on log file!
  
🛠️ **CONTROL COMMANDS**
---------------------------------
- 🔹 `quit` or `exit`  → Closes the `lftp` session

## 

## ☕ Support the Project

Do you like this project? If you find it useful, buy me a virtual coffee to support future developments! Every small contribution is greatly appreciated. 🙏

**LFTP Worker is and will always remain free and open source.** Donations are completely voluntary! ❤️

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Prefer other methods?** You can use:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)
