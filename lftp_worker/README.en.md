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

