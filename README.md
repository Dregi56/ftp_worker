# 🚀 LFTP Worker Add-on for Home Assistant

A **universal LFTP engine** for Home Assistant designed to run **advanced FTP workflows in a single persistent session**.  
Perfect for automations, scheduled maintenance, and bidirectional folder mirroring — **no reconnects, no fragile scripts**.

---

## ✨ Why LFTP Worker?

Most FTP integrations reconnect for every operation.  
**LFTP Worker stays alive**, listens on `stdin`, and executes **complex command chains in one session**.

### What you gain:
- ✅ Faster transfers (no repeated logins)
- ✅ Reliable automations
- ✅ Advanced LFTP features exposed to Home Assistant
- ✅ Clean logs and controlled verbosity

---

## 🧠 Key Features

- **Universal LFTP Engine**  
  Supports advanced LFTP commands, passive mode, and robust error handling.

- **Persistent Session via stdin**  
  Send complex command chains in one go — uploads, downloads, cleanup, sync.

- **Dynamic Commands**  
  Not limited to predefined actions. Execute **any LFTP command** from automations.

- **Folder Mirroring**  
  Keep local and remote directories synchronized, optionally filtered by file extension.

- **Secure Configuration**  
  FTP credentials are safely stored inside the add-on configuration.

---

## 🎯 Typical Use Cases

- 📦 Automatically upload media files
- 🧹 Clean remote FTP folders on a schedule
- 🔁 Mirror local ↔ remote directories
- 🤖 Fully control FTP workflows via Home Assistant automations
- 🛠️ Replace fragile shell scripts with a stable LFTP session

---

## 👤 Author

Created by **Egidio Ziggiotto - Dregi56**  
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on)

---

## 📄 License

This project is released under the **MIT License**.  
You are free to use, modify, and distribute it, provided that the original author is credited.

---

## ℹ️ Project Information

**Last Update:** January 08, 2026  
🏷️ **Current Version:** `1.2.21` — *Universal Edition*

---

## 📦 Installation

1. Copy your GitHub repository URL.
2. In Home Assistant go to **Settings** → **Add-ons** → **Add-on Store**.
3. Click the three dots (top right) and select **Repositories**.
4. Paste the repository URL:  
   `https://github.com/Dregi56/ftp_worker`  
   then click **Add**.
5. Search for **LFTP FTP Worker**, open it, and click **Install**.

---

## ⚙️ Configuration

After installation, open the **Configuration** tab and set:

### Required
- `host` — FTP server address (e.g. `ftp.mysite.com`)
- `user` — FTP username
- `psw` — FTP password

### Optional (for synchronization mode)
- `local_dir` — Local directory
- `remote_dir` — Remote directory
- `interval` — Sync interval (seconds)
- `extensions` — File extensions (e.g. `txt,mp4`)

🔹 **Note**  
By default, **Run at startup** is disabled to avoid wasting resources with an always-open FTP connection.  
If you use synchronization mode, enabling it is recommended.

---

## 🤖 Usage via Automations (stdin mode)

Leave `local_dir`, `remote_dir`, and `interval` empty.  
The add-on starts idle and waits for commands.

To send commands, use the service:

hassio.addon_stdin

⚠️ **Important**
- Only **one command line** can be sent at a time
- Multiple commands can be chained using `;`

---

## 📘 Example: Weekly FTP Maintenance

This automation:
- Starts the add-on
- Cleans a remote folder
- Uploads new `.mp4` files
- Cleans local folders
- Closes the FTP session
- Stops the add-on

```yaml
- id: weekly_ftp_sync
  alias: "Weekly FTP Video Maintenance"
  description: "Cleans remote, uploads new MP4s, and clears local folders every Monday night"
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

    # 2. Send LFTP commands (single session)
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: "set cmd:verbose yes; cd /public/da_sud; rm -rf *; mput /media/da_sud/*.mp4"

    # 3. Wait for transfer completion
    - delay: "00:05:00"

    # 4. Local cleanup
    - service: shell_command.clean_local_da_sud
    - service: shell_command.clean_local_est_piazzola

    # 5. Close LFTP session
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: quit

    # 6. Stop add-on
    - service: hassio.addon_stop
      data:
        addon: "6d4a8c9b_lftp_worker"
  mode: single

🔁 Synchronization Mode

Set local_dir, remote_dir, and optionally interval.

If interval is set → continuous synchronization

If interval is empty → one-time sync at startup

If extensions is empty → all files are synced

Multiple extensions are supported (e.g. txt,mp4,doc)

For this mode, enabling Run at startup and Watchdog is recommended.

📁 Basic Transfer Commands

get <file> → Download one remote file

mget <pattern> → Download multiple files (e.g. *.mp4)

put <file> → Upload one local file

mput <pattern> → Upload multiple local files

🔄 Synchronization Commands

mirror <remote> <local> → Sync remote → local

mirror -c <remote> <local> → Sync only new files

mirror --reverse <local> <remote> → Sync local → remote

📌 Useful Remote File Commands

mkdir <dir> → Create remote directory

rm <file> → Delete remote file

mrm <pattern> → Delete multiple remote files

mv <src> <dst> → Rename or move a remote file

⚠️ Note
These commands do not produce output in the add-on log.

🛠️ Control Commands

quit or exit → Close the LFTP session

☕ Support the Project

If you like this project and find it useful, consider buying me a virtual coffee ☺️
Every contribution helps support future development.

LFTP Worker is and will always remain free and open source.
Donations are completely voluntary ❤️

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Preferisci altri metodi?** Puoi usare:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)

  
