# 🚀 LFTP Worker Add-on for Home Assistant
Created by Egidio Ziggiotto - Dregi56
📧 dregi@cyberservices.com.
<br>
License
This project is released under the MIT License. You are free to use, modify, and distribute it, provided you credit the original author.
<br>
Project Information
Last Updated: January 08, 2026
<br>
🏷️ Current Version: 1.2.21 "Universal Edition"

Changelog
v1.2.21 (01/08/2026): Changes for interactivity in the add-on logs.

v1.2.7 (12/27/2025): Configured FIFO for output in the add-on logs.

v1.2.4 (12/24/2025): Added verbose no to keep the logs clean.

v1.2.3 (12/24/2025): Renamed add-on to LFTP Worker and added author email.

v1.2.0 (12/24/2025): Added possibility to configure mirroring between local and remote directories (one-time at startup or scheduled).

v1.1.6 (12/24/2025): Set "Start on boot" to off by default. Added LFTP command examples here.

v1.1.5 (12/24/2025): Changed add-on name. Fixed some log output messages.

v1.1.4 (12/24/2025): Fixed bug caused by remote server login failure.

v1.1.3 (12/23/2025): Valid startup!

v1.0.7 (12/23/2025): Directory bug fix.

v1.0.6 (12/23/2025): run.sh bug fix.

v1.0.5 (12/23/2025): Transformation into a universal engine via stdin. Added dynamic management of LFTP commands.

v1.0.0: Initial FTP worker version.

📝 Description
This Home Assistant add-on is a universal LFTP engine designed to efficiently handle file transfers between your local instance and a remote FTP server. Unlike other methods, this add-on stays listening and processes complex commands via standard input (stdin), allowing you to perform cleanup, uploads, and downloads in a single session without multiple reconnections.
It is also possible to set the add-on to mirror two folders, including filtering the files you want to keep updated.

✨ Features

LFTP Engine: Supports advanced operations, passive mode, and robust error handling.

Dynamic Commands: Not limited to a fixed function; accepts any LFTP command via automations.

Mirroring: You can define two folders to keep in sync within the options.

Security: FTP credentials are securely stored in the add-on configuration.

📌 Installation

Copy your GitHub repository URL.

In Home Assistant, go to Settings > Add-ons > Add-on Store.

Click the three dots in the top right corner and select Repositories.

Paste the repository URL (https://github.com/Dregi56/ftp_worker) and click Add.

Look for "LFTP FTP Worker" in the list of available add-ons, click on it, and press Install.

📌 Configuration

Once installed, go to the Configuration tab and fill in the following fields:

host: Your FTP server address (e.g., ftp.mysite.com).

user: Your FTP username.

psw: Your FTP password.

Optional for synchronization:

local_dir: Local folder path.

remote_dir: Remote folder path.

interval: Expressed in seconds.

extensions: e.g., txt, mp4.

  🔹 Note: By default, Start on boot is set to off, as it is unnecessary and resource-heavy to maintain a constant connection to the remote server.                If you are using the add-on for synchronization, you should set it to ON.
🎯 Usage via Automations

For this use case, leave the local_dir, remote_dir, and interval inputs empty in the Configuration.
The add-on does nothing at startup but remains waiting. To send commands, use the hassio.addon_stdin service.


⚠️ IMPORTANT NOTE: You can execute only one command line at a time. However, you can chain commands by separating them with a semicolon (;).

Example: Weekly Maintenance
This automation starts the add-on, cleans remote folders, uploads new .mp4 files, closes the connection, cleans local folders, and turns off the add-on.

YAML
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
        input: "set cmd:verbose yes; cd /public/south_cam; rm -rf *; mput /media/south_cam/*.mp4"
    # 3. Wait after transfer completion 
    - delay: "00:05:00"
    # 4. Local cleanup
    - service: shell_command.cleanup_local_south
    - service: shell_command.cleanup_local_east
    # 5. Stop the connection
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: quit
    # 6. Stop add-on
    - service: hassio.addon_stop
      data:
        addon: "6d4a8c9b_lftp_worker"
  mode: single
🎯 Usage for Synchronization

For this use case, set the local_dir, remote_dir, and interval inputs in the Configuration section.
You can maintain constant synchronization between two folders (one local and one remote) by setting the folder names in the add-on configuration.
If interval is not set, synchronization will occur only once when the add-on starts (which can be triggered from an automation).
If extension is left empty, all files in the folder will be synchronized; otherwise, only those with the specified extension.
Multiple file types can be indicated, e.g., txt, mp4, doc.
For this usage, it may be useful to set Start on boot and Watchdog to ON.

📁 BASIC TRANSFER COMMANDS
🔹 get <file>      → Download a single remote file

🔹 mget <pattern> → Download multiple files matching the pattern (e.g., *.mp4)

🔹 put <file>      → Upload a single local file

🔹 mput <pattern> → Upload multiple files from local to remote

🔄 SYNCHRONIZATION COMMANDS
🔹 mirror <remote> <local>          → Sync directory remote → local

🔹 mirror -c <remote> <local>       → Sync new files only

🔹 mirror --reverse <local> <remote> → Sync local → remote (upload)

📌 USEFUL REMOTE FILE COMMANDS
🔹 mkdir <dir>    → Create remote directory

🔹 rm <file>      → Delete remote file

🔹 mrm <pattern>  → Delete multiple remote files (with wildcards)

🔹 mv <src> <dst> → Rename or move a remote file


  ⚠️ IMPORTANT NOTE
All these commands do not provide feedback in the add-on log file!

🛠️ CONTROL COMMANDS
🔹 quit or exit  → Closes the lftp session


☕ Support the Project

If you like this project and find it useful, consider buying me a virtual coffee ☺️
Every contribution helps support future development.

LFTP Worker is and will always remain free and open source.
Donations are completely voluntary ❤️

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Preferisci altri metodi?** Puoi usare:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)

  
