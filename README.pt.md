# 🚀 LFTP Worker Add-on for Home Assistant
---

## Autor
Criado por **Egidio Ziggiotto - Dregi56**<br>
📧 [dregi@cyberservices.com](mailto:dregi@cyberservices.com?subject=Info%20LFTP%20Worker%20Add-on).

![Vesion](https://img.shields.io/github/v/release/Dregi56/ftp_worker?color=orange&label=latest%20version)
![License](https://img.shields.io/badge/license-MIT-green)
![Home Assistant](https://img.shields.io/badge/Home%20Assistant-Add--on-blue?logo=home-assistant)
![Downloads](https://img.shields.io/github/github/downloads/Dregi56/ftp_worker/total?color=blue&label=downloads)
![Stars](https://img.shields.io/github/stars/Dregi56/ftp_worker?style=social)

🌍 **Languages:**  
[🇬🇧 English](README.md) | [🇮🇹 Italiano](README.it.md) | [🇪🇸 Español](README.es.md) | [🇵🇹 Português](README.pt.md) | [🇫🇷 Français](README.fr.md)

## Informações do Projeto
**Data da última atualização:** ![GitHub last commit](https://img.shields.io/github/last-commit/Dregi56/ftp_worker?label=%20)  
🏷️ **Versão atual:** ![GitHub release (latest by date)](https://img.shields.io/github/v/release/Dregi56/ftp_worker?label=%20) "Universal Edition"


## Registro de Alterações
- **v1.2.21 (08/01/2026):** Melhorias na interatividade do registro (log) do add-on
- **v1.2.7 (27/12/2025):** Configuração FIFO para saída no log do add-on
- **v1.2.4 (24/12/2025):** Adicionado `verbose no` para manter o log limpo.
- **v1.2.3 (24/12/2025):** Renomeado o add-on para LFTP Worker e adicionada a e-mail do autor.
- **v1.2.0 (24/12/2025):** Possibilidade de configurar um mirror entre dois diretórios, local e remoto, uma única vez na inicialização ou de forma periódica.
- **v1.1.6 (24/12/2025):** Executar na inicialização definido como off. Adicionados exemplos de comandos lftp.
- **v1.1.5 (24/12/2025):** Alterado o nome do add-on. Corrigidas algumas entradas retornadas no log.
- **v1.1.4 (24/12/2025):** Corrigido bug causado por falha de login no servidor remoto.
- **v1.1.3 (23/12/2025):** Inicialização válida!
- **v1.0.7 (23/12/2025):** Correção de bug em diretórios.
- **v1.0.6 (23/12/2025):** Correção de bug run.sh
- **v1.0.5 (23/12/2025):** Transformação em motor universal via `stdin`. Adicionada gestão dinâmica de comandos lftp.
- **v1.0.0:** Versão inicial do worker FTP.

---

## 📌 Instalação

### 🏠 Instalação Rápida (Recomendada)

Adicione este repositório diretamente à sua instância do Home Assistant:

[![Open your Home Assistant instance and add this repository](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https://github.com/Dregi56/ftp_worker)

---

### 🔧 Instalação Manual

1. Copie a URL do seu repositório no GitHub.  
2. No Home Assistant, vá em **Settings** > **Add-ons** > **Add-on Store**.  
3. Clique nos três pontos no canto superior direito e selecione **Repositories**.  
4. Cole a URL do repositório (`https://github.com/Dregi56/ftp_worker`) e clique em **Add**.  
5. Procure por **"LFTP FTP Worker"**, clique nele e pressione **Install**.  

📝 Descrição  
Este add-on para Home Assistant é um **motor universal LFTP** projetado para gerenciar transferências de arquivos entre a instância local e um servidor FTP remoto de forma eficiente.  
Diferentemente de outros métodos, este add-on permanece em escuta e processa comandos complexos através da entrada padrão (`stdin`), permitindo executar limpezas, uploads e downloads em uma única sessão sem múltiplas reconexões.  
Também é possível configurar o add-on em modo mirroring entre duas pastas, inclusive filtrando os arquivos que devem permanecer sincronizados.

✨ Características
* **Motor LFTP**: Suporta operações avançadas, modo passivo e gestão robusta de erros.
* **Comandos Dinâmicos**: Não é limitado a uma função fixa; aceita qualquer comando LFTP via automações.
* **Mirroring**: É possível definir duas pastas para manter sincronizadas.
* **Segurança**: As credenciais FTP são armazenadas com segurança na configuração do add-on.

---
---

📌 Configuração

Após a instalação, vá até a aba **Configuração** e preencha os seguintes campos:

* `host`: Endereço do seu servidor FTP (ex: `ftp.meusite.it`).
* `user`: Seu nome de usuário FTP.
* `psw`: Sua senha FTP.

Opcionais para sincronização:
* `local_dir`: Pasta local.
* `remote_dir`: Pasta remota.
* `interval`: Expresso em segundos.
* `extensions`: ex. txt, mp4

🔹 **Nota:** Por padrão, a opção **Executar na inicialização** está desativada, pois manter uma conexão aberta com o servidor remoto consome recursos desnecessariamente.  
Se você estiver utilizando o add-on para sincronização, recomenda-se ativá-la.

---

🎯 Uso via Automações

Para este uso, deixe vazios na Configuração os campos `local_dir`, `remote_dir` e `interval`.  
O add-on não executa nada ao iniciar, permanecendo em espera.  
Para enviar comandos, utilize o serviço `hassio.addon_stdin`.

⚠️ **NOTA IMPORTANTE:** É possível executar **apenas uma linha de comando por vez**, mas você pode concatenar vários comandos separando-os com ponto e vírgula.

### Exemplo: Manutenção Semanal

Esta automação inicia o add-on, limpa as pastas remotas, envia novos arquivos `.mp4`, encerra a conexão, limpa as pastas locais e desliga o add-on.

```yaml
- id: weekly_ftp_sync
  alias: "Manutenção Semanal Vídeo FTP"
  description: "Limpa remoto, envia novos MP4 e esvazia local toda segunda-feira à noite"
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

🎯 Uso para Sincronização

Para este uso, configure `local_dir`, `remote_dir` e `interval` na seção **Configuração**.  

É possível manter uma sincronização constante entre duas pastas (uma local e outra remota), definindo seus nomes na configuração do add-on.  

Se `interval` não for definido, a sincronização ocorrerá apenas uma vez na inicialização do add-on (que pode ser acionada via automação).  

Se `extensions` for deixado vazio, todos os arquivos da pasta serão sincronizados; caso contrário, apenas aqueles com as extensões indicadas.  
É possível especificar múltiplos tipos de arquivo, por exemplo: txt, mp4, doc.  

Para este uso pode ser útil ativar **Executar na inicialização** e **Watchdog**.

---

📁 **COMANDOS BÁSICOS DE TRANSFERÊNCIA**
---------------------------------
- 🔹 `get <file>`     → Baixa **um arquivo remoto**
- 🔹 `mget <pattern>` → Baixa **vários arquivos** que correspondam ao padrão (ex. `*.mp4`)
- 🔹 `put <file>`     → Envia **um arquivo local**
- 🔹 `mput <pattern>` → Envia **vários arquivos** do local para o remoto

🔄 **COMANDOS DE SINCRONIZAÇÃO**
---------------------------------
- 🔹 `mirror <remote> <local>`           → Sincroniza diretório **remoto → local**
- 🔹 `mirror -c <remote> <local>`        → Sincroniza **apenas arquivos novos**
- 🔹 `mirror --reverse <local> <remote>` → Sincroniza **local → remoto** (upload)

📌 **COMANDOS ÚTEIS PARA ARQUIVOS REMOTOS**
---------------------------------
- 🔹 `mkdir <dir>`    → Cria diretório remoto
- 🔹 `rm <file>`      → Remove arquivo remoto
- 🔹 `mrm <pattern>`  → Remove vários arquivos remotos (com wildcard)
- 🔹 `mv <src> <dst>` → Renomeia ou move um arquivo remoto

⚠️ **NOTA IMPORTANTE**  
Esses comandos não exibem nenhum retorno no log do add-on.

🛠️ **COMANDOS DE CONTROLE**
---------------------------------
- 🔹 `quit` ou `exit` → Encerra a sessão `lftp`

---

## ☕ Apoie o projeto

Gostou deste projeto? Se ele for útil para você, ofereça um café virtual para apoiar futuras melhorias! Qualquer contribuição é muito apreciada 🙏  

**LFTP Worker é e sempre será gratuito e open source.** As doações são totalmente voluntárias ❤️  

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/dregi56)

💡 **Prefere outros métodos?** Você pode usar:

[![revolut](https://img.shields.io/badge/Revolut-0075EB?style=for-the-badge&logo=revolut&logoColor=white)](https://revolut.me/egidio5t9d)
