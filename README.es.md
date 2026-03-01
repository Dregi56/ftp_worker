# 🚀 LFTP Worker Add-on for Home Assistant
---

## Autor
Creado por **Egidio Ziggiotto - Dregi56**<br>
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on).

![Vesion](https://img.shields.io/github/v/release/Dregi56/ftp_worker?color=orange&label=latest%20version)
![License](https://img.shields.io/badge/license-MIT-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue?logo=home-assistant)
![Downloads](https://img.shields.io/github/downloads/Dregi56/ftp_worker/total?color=blue&label=downloads)
![Stars](https://img.shields.io/github/stars/Dregi56/ftp_worker?style=social)


🌍 **Languages:**  
[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇵🇹 Português](README.pt.md) | [🇫🇷 Français](README.fr.md)

## Información del Proyecto
**Fecha de última actualización::**  ![GitHub last commit](https://img.shields.io/github/last-commit/Dregi56/ftp_worker?label=%20) 
<br>🏷️ **Versión actual:**  ![GitHub release (latest by date)](https://img.shields.io/github/v/release/Dregi56/ftp_worker?label=%20) "Universal Edition"

## Registro de Cambios
- **v1.2.21 (08/01/2026):** Mejoras en la interactividad del registro del add-on
- **v1.2.7 (27/12/2025):** Configuración FIFO para la salida en el registro del add-on
- **v1.2.4 (24/12/2025):** Añadido `verbose no` para mantener limpio el registro.
- **v1.2.3 (24/12/2025):** Renombrado el add-on a LFTP Worker y añadida la e-mail del autor.
- **v1.2.0 (24/12/2025):** Posibilidad de configurar un mirror entre dos directorios, local y remoto, una sola vez al inicio o de forma periódica.
- **v1.1.6 (24/12/2025):** Ejecutar al inicio configurado en off. Añadidos ejemplos de comandos lftp.
- **v1.1.5 (24/12/2025):** Cambiado el nombre del add-on. Corregidas algunas entradas del registro.
- **v1.1.4 (24/12/2025):** Corregido bug causado por fallo de login en el servidor remoto.
- **v1.1.3 (23/12/2025):** ¡Inicio válido!
- **v1.0.7 (23/12/2025):** Corrección bug directorios.
- **v1.0.6 (23/12/2025):** Corrección bug run.sh
- **v1.0.5 (23/12/2025):** Transformación en motor universal mediante `stdin`. Añadida gestión dinámica de comandos lftp.
- **v1.0.0:** Versión inicial del worker FTP.

---

## 📌 Instalación

### 🏠 Instalación rápida (Recomendada)

Añade este repositorio directamente a tu instancia de Home Assistant:

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/Dregi56/ftp_worker)

---

### 🔧 Instalación manual

1. Copia la URL de tu repositorio de GitHub.  
2. En Home Assistant ve a **Settings** > **Add-ons** > **Add-on Store**.  
3. Haz clic en los tres puntos arriba a la derecha y selecciona **Repositories**.  
4. Pega la URL del repositorio (`https://github.com/Dregi56/ftp_worker`) y pulsa **Add**.  
5. Busca **"LFTP FTP Worker"**, haz clic y presiona **Install**.  

📝 Descripción  
Este add-on para Home Assistant es un **motor universal LFTP** diseñado para gestionar transferencias de archivos entre la instancia local y un servidor FTP remoto de forma eficiente.  
A diferencia de otros métodos, este add-on permanece en escucha y procesa comandos complejos mediante la entrada estándar (`stdin`), permitiendo ejecutar limpiezas, subidas y descargas en una única sesión sin múltiples reconexiones.  
También es posible configurar el add-on en modo mirroring entre dos carpetas, incluso filtrando los archivos que se desean mantener sincronizados.

✨ Características
* **Motor LFTP**: Soporta operaciones avanzadas, modo pasivo y gestión robusta de errores.
* **Comandos dinámicos**: No está limitado a una función fija; acepta cualquier comando LFTP mediante automatizaciones.
* **Mirroring**: Se pueden definir dos carpetas para mantener sincronizadas.
* **Seguridad**: Las credenciales FTP se guardan de forma segura en la configuración del add-on.

---
---

📌 Configuración

Una vez instalado, ve a la pestaña **Configuración** y completa los siguientes campos:

* `host`: Dirección de tu servidor FTP (ej: `ftp.misitio.it`).
* `user`: Tu nombre de usuario FTP.
* `psw`: Tu contraseña FTP.

Opcionales para sincronización:
* `local_dir`: Carpeta local.
* `remote_dir`: Carpeta remota.
* `interval`: Expresado en segundos.
* `extensions`: ej. txt, mp4

🔹 **Nota:** Por defecto la opción **Ejecutar al inicio** está desactivada, ya que mantener abierta una conexión con el servidor remoto consume recursos innecesarios.  
Si utilizas el add-on para sincronización, es recomendable activarla.

---

🎯 Uso mediante Automatizaciones

Para este uso, deja vacíos en Configuración los campos `local_dir`, `remote_dir` e `interval`.  
El add-on no ejecuta nada al inicio, sino que permanece en espera.  
Para enviar comandos utiliza el servicio `hassio.addon_stdin`.

⚠️ **NOTA IMPORTANTE**: Solo es posible ejecutar **una línea de comando a la vez**, pero puedes concatenar varios comandos separándolos con punto y coma.

### Ejemplo: Mantenimiento semanal

Esta automatización inicia el add-on, limpia las carpetas remotas, sube nuevos archivos `.mp4`, cierra la conexión, limpia las carpetas locales y apaga el add-on.

```yaml
- id: weekly_ftp_sync
  alias: "Mantenimiento Semanal Video FTP"
  description: "Limpia remoto, sube nuevos MP4 y vacía local cada lunes por la noche"
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

🎯 Uso para sincronización

Para este uso configura `local_dir`, `remote_dir` e `interval` en la sección **Configuración**.  

Es posible mantener una sincronización constante entre dos carpetas (local y remota) definiendo sus nombres en la configuración del add-on.  

Si no se define `interval`, la sincronización se ejecutará una sola vez al iniciar el add-on (inicio que puede activarse desde una automatización).  

Si se deja vacío `extensions`, se sincronizarán todos los archivos de la carpeta; de lo contrario, solo los que coincidan con las extensiones indicadas.  
Se pueden indicar múltiples tipos de archivo, por ejemplo: txt, mp4, doc.  

Para este uso puede ser útil activar **Ejecutar al inicio** y **Watchdog**.

---

📁 **COMANDOS BÁSICOS DE TRANSFERENCIA**
---------------------------------
- 🔹 `get <file>`     → Descarga **un archivo remoto**
- 🔹 `mget <pattern>` → Descarga **varios archivos** que coincidan con el patrón (ej. `*.mp4`)
- 🔹 `put <file>`     → Sube **un archivo local**
- 🔹 `mput <pattern>` → Sube **varios archivos** de local a remoto

🔄 **COMANDOS DE SINCRONIZACIÓN**
---------------------------------
- 🔹 `mirror <remote> <local>`           → Sincroniza directorio **remoto → local**
- 🔹 `mirror -c <remote> <local>`        → Sincroniza **solo archivos nuevos**
- 🔹 `mirror --reverse <local> <remote>` → Sincroniza **local → remoto** (subida)

📌 **COMANDOS ÚTILES PARA ARCHIVOS REMOTOS**
---------------------------------
- 🔹 `mkdir <dir>`    → Crea directorio remoto
- 🔹 `rm <file>`      → Elimina archivo remoto
- 🔹 `mrm <pattern>`  → Elimina varios archivos remotos (con comodín)
- 🔹 `mv <src> <dst>` → Renombra o mueve un archivo remoto

⚠️ **NOTA IMPORTANTE**  
Estos comandos no muestran ningún resultado en el registro del add-on.

🛠️ **COMANDOS DE CONTROL**
---------------------------------
- 🔹 `quit` o `exit` → Cierra la sesión `lftp`

---

## ☕ Apoya el proyecto

¿Te gusta este proyecto? Si lo encuentras útil, invítame a un café virtual para apoyar futuras mejoras. ¡Cualquier contribución es muy apreciada! 🙏  

**LFTP Worker es y seguirá siendo siempre gratuito y open source.** Las donaciones son completamente voluntarias ❤️  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **¿Prefieres otros métodos?** Puedes usar:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)
