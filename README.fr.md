# 🚀 LFTP Worker Add-on for Home Assistant
---

## Auteur
Créé par **Egidio Ziggiotto - Dregi56**<br>
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on).

![Version](https://img.shields.io/badge/version-1.2.21-blue)
![License](https://img.shields.io/badge/license-MIT-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue?logo=home-assistant)
![Downloads](https://img.shields.io/github/downloads/Dregi56/ftp_worker/total)
![Stars](https://img.shields.io/github/github-stars/Dregi56/ftp_worker?style=flat)
![Latest Release](https://img.shields.io/github/v/release/Dregi56/ftp_worker)


🌍 **Languages:**  
[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇵🇹 Português](README.pt.md) | [🇫🇷 Français](README.fr.md)

## Informations sur le Projet
**Dernière mise à jour :** 08 Janvier 2026<br>
🏷️ **Version actuelle :** 1.2.21 "Universal Edition"

## Journal des Modifications
- **v1.2.21 (08/01/2026) :** Modifications pour interactivité dans le log de l’add-on
- **v1.2.7 (27/12/2025) :** FIFO configuré pour la sortie dans le log
- **v1.2.4 (24/12/2025) :** Ajout de `verbose no` pour garder le log propre
- **v1.2.3 (24/12/2025) :** Add-on renommé en LFTP Worker et ajout de l’e-mail de l’auteur
- **v1.2.0 (24/12/2025) :** Possibilité de configurer un miroir entre deux répertoires, local et distant, une seule fois au démarrage ou périodiquement
- **v1.1.6 (24/12/2025) :** Exécution au démarrage définie sur off. Exemples de commandes lftp ajoutés
- **v1.1.5 (24/12/2025) :** Nom du add-on changé. Certaines entrées de log corrigées
- **v1.1.4 (24/12/2025) :** Bug causé par échec de login corrigé
- **v1.1.3 (23/12/2025) :** Démarrage valide !
- **v1.0.7 (23/12/2025) :** Correction bug de répertoire
- **v1.0.6 (23/12/2025) :** Correction bug run.sh
- **v1.0.5 (23/12/2025) :** Transformation en moteur universel via `stdin`. Gestion dynamique des commandes lftp ajoutée
- **v1.0.0 :** Version initiale du worker FTP

---

## 📌 Installation

### 🏠 Installation Rapide (Recommandée)

Ajoutez ce dépôt directement à votre instance Home Assistant :

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/Dregi56/ftp_worker)

---

### 🔧 Installation Manuelle

1. Copiez l’URL de votre dépôt GitHub.  
2. Dans Home Assistant, allez dans **Settings** > **Add-ons** > **Add-on Store**.  
3. Cliquez sur les trois points en haut à droite et sélectionnez **Repositories**.  
4. Collez l’URL du dépôt (`https://github.com/Dregi56/ftp_worker`) et cliquez sur **Add**.  
5. Recherchez **"LFTP FTP Worker"**, cliquez dessus et appuyez sur **Install**.  

📝 Description  
Cet add-on pour Home Assistant est un **moteur LFTP universel** conçu pour gérer efficacement les transferts de fichiers entre l’instance locale et un serveur FTP distant.  
Contrairement à d’autres méthodes, cet add-on reste en écoute et traite des commandes complexes via l’entrée standard (`stdin`), permettant d’exécuter nettoyage, upload et download en une seule session sans multiples reconnexions.  
Il est également possible de mettre l’add-on en mode miroir entre deux dossiers, en filtrant les fichiers à maintenir à jour.

✨ Fonctionnalités
* **Moteur LFTP** : Supporte les opérations avancées, le mode passif et une gestion robuste des erreurs
* **Commandes Dynamiques** : Accepte toute commande LFTP via des automatisations, pas seulement une fonction fixe
* **Mirroring** : Deux dossiers peuvent être définis pour rester synchronisés
* **Sécurité** : Les identifiants FTP sont stockés de manière sécurisée dans la configuration de l’add-on

---
---

📌 Configuration

Après l’installation, allez dans l’onglet **Configuration** et remplissez les champs suivants :

* `host` : Adresse de votre serveur FTP (ex : `ftp.monsite.it`)  
* `user` : Nom d’utilisateur FTP  
* `psw` : Mot de passe FTP  

Optionnels pour la synchronisation :  
* `local_dir` : Dossier local  
* `remote_dir` : Dossier distant  
* `interval` : Exprimé en secondes  
* `extensions` : ex. txt, mp4  

🔹 **Remarque :** Par défaut, **Exécuter au démarrage** est désactivé car maintenir une connexion ouverte avec le serveur distant consomme des ressources inutiles.  
Si vous utilisez l’add-on pour la synchronisation, il est recommandé de l’activer.

---

🎯 Utilisation via Automatisations

Pour cette utilisation, laissez les champs `local_dir`, `remote_dir` et `interval` vides dans la configuration.  
L’add-on ne fait rien au démarrage et reste en attente.  
Pour envoyer des commandes, utilisez le service `hassio.addon_stdin`.

⚠️ **NOTE IMPORTANTE :** Vous ne pouvez exécuter **qu’une seule ligne de commande à la fois**, mais vous pouvez enchaîner plusieurs commandes en les séparant par un point-virgule.

### Exemple : Maintenance Hebdomadaire

Cette automatisation démarre l’add-on, nettoie les dossiers distants, téléverse les nouveaux fichiers `.mp4`, ferme la connexion, nettoie les dossiers locaux et arrête l’add-on.

```yaml
- id: weekly_ftp_sync
  alias: "Maintenance Hebdomadaire Vidéo FTP"
  description: "Nettoie le distant, téléverse nouveaux MP4 et vide le local chaque lundi soir"
  trigger:
    - platform: time
      at: "03:00:00"
  condition:
    - condition: time
      weekday:
        - mon
  action:
    - service: hassio.addon_start
      data:
        addon: "6d4a8c9b_lftp_worker"
    - delay: "00:00:20"
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: "set cmd:verbose yes; cd /public/da_sud; rm -rf *; mput /media/da_sud/*.mp4"
    - delay: "00:05:00"
    - service: shell_command.pulisci_locale_da_sud
    - service: shell_command.pulisci_locale_est_piazzola
    - service: hassio.addon_stdin
      data:
        addon: "6d4a8c9b_lftp_worker"
        input: quit
    - service: hassio.addon_stop
      data:
        addon: "6d4a8c9b_lftp_worker"
  mode: single
```

---

🎯 Utilisation pour Synchronisation

Pour cette utilisation, configurez `local_dir`, `remote_dir` et `interval` dans la section **Configuration**.  

Il est possible de maintenir une synchronisation constante entre deux dossiers (local et distant) en définissant leurs noms dans la configuration de l’add-on.  

Si `interval` n’est pas défini, la synchronisation se fera une seule fois au démarrage de l’add-on (qui peut être déclenché par une automatisation).  

Si `extensions` est vide, tous les fichiers du dossier seront synchronisés ; sinon, seuls ceux avec les extensions indiquées.  
Vous pouvez spécifier plusieurs types de fichiers, par ex. txt, mp4, doc.  

Pour cette utilisation, il peut être utile d’activer **Exécuter au démarrage** et **Watchdog**.

---

📁 **COMMANDES DE TRANSFERT DE BASE**
---------------------------------
- 🔹 `get <file>`     → Télécharge **un fichier distant**
- 🔹 `mget <pattern>` → Télécharge **plusieurs fichiers** correspondant au motif (ex. `*.mp4`)
- 🔹 `put <file>`     → Téléverse **un fichier local**
- 🔹 `mput <pattern>` → Téléverse **plusieurs fichiers** du local vers le distant

🔄 **COMMANDES DE SYNCHRONISATION**
---------------------------------
- 🔹 `mirror <remote> <local>`           → Synchronise le répertoire **distant → local**
- 🔹 `mirror -c <remote> <local>`        → Synchronise **seulement les nouveaux fichiers**
- 🔹 `mirror --reverse <local> <remote>` → Synchronise **local → distant** (upload)

📌 **COMMANDES UTILES POUR LES FICHIERS DISTANTS**
---------------------------------
- 🔹 `mkdir <dir>`    → Crée un répertoire distant
- 🔹 `rm <file>`      → Supprime un fichier distant
- 🔹 `mrm <pattern>`  → Supprime plusieurs fichiers distants (wildcard)
- 🔹 `mv <src> <dst>` → Renomme ou déplace un fichier distant

⚠️ **NOTE IMPORTANTE**  
Ces commandes ne renvoient aucun retour dans le log de l’add-on.

🛠️ **COMMANDES DE CONTRÔLE**
---------------------------------
- 🔹 `quit` ou `exit` → Ferme la session `lftp`

---

## ☕ Soutenez le projet

Vous aimez ce projet ? Si vous le trouvez utile, offrez un café virtuel pour soutenir les futures évolutions ! Chaque petite contribution est grandement appréciée 🙏  

**LFTP Worker est et restera toujours gratuit et open source.** Les donations sont entièrement volontaires ❤️  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Préférez d’autres méthodes ?** Vous pouvez utiliser :

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)
