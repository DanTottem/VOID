> ⚠️ Este projeto foi reescrito como aplicativo desktop em Flutter.
> Acesse a nova versão: [V.O.I.D. Flutter]([link do novo repo](https://github.com/DanTottem/VOID-Cleaner))
> 
# 🌌 V.O.I.D. (Virtual Optimization & Internal Deletion)

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?style=for-the-badge&logo=powershell)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Windows-0078D6?style=for-the-badge&logo=windows)

O **V.O.I.D.** é um utilitário de linha de comando robusto para Windows, projetado para realizar a manutenção profunda do sistema. Ele foca na eliminação de arquivos desnecessários e caches que degradam a performance ao longo do tempo.

---

## 🚀 Principais Recursos

* **⚡ Limpeza de Shaders:** Remove caches de GPU (NVIDIA e DirectX) para mitigar *stuttering* e quedas de FPS em jogos.
* **🗑️ Gestão de Lixeira:** Integração direta com o sistema para esvaziamento completo e cálculo de espaço recuperado.
* **🔍 Pré-Análise Inteligente:** Calcula o tamanho exato dos dados antes de qualquer alteração.
* **🛡️ Remoção Segura:** Detecta arquivos em uso e os ignora automaticamente para evitar instabilidade.
* **📊 Relatórios Granulares:** Exibição detalhada por categoria com porcentagem de eficiência.

---

## 📂 Áreas de Atuação

| Categoria | Descrição |
| :--- | :--- |
| **Lixeira** | Esvaziamento completo de todos os drives do sistema. |
| **Temporários** | Limpeza de pastas `%TEMP%` de usuário e sistema. |
| **Prefetch** | Otimização de dados de inicialização de aplicações. |
| **NVIDIA Cache** | Remoção de DXCache e NV_Cache para drivers de vídeo. |
| **DirectX Cache** | Limpeza do Shader Cache central do Windows. |
| **Logs de Sistema** | Remoção de logs de Update, CBS e Software Distribution. |

> [!TIP]
> **Aviso para usuários AMD:** O script vem configurado nativamente para NVIDIA. Se você utiliza uma placa de vídeo **AMD**, você mesmo pode realizar as mudanças no código para incluir os caminhos de cache específicos da marca (geralmente localizados em `%LocalAppData%\AMD\DxCache`).

---

## 🛠️ Como Utilizar

O V.O.I.D. já vem pronto para uso imediato. Não é necessário configurar scripts manualmente.

### 1. Execução via Arquivo .bat (Recomendado)
Para facilitar, o repositório já inclui o arquivo `VOID.bat`. Ele automatiza a elevação de privilégios de administrador e ignora restrições de política do PowerShell.
* **Basta clicar duas vezes no arquivo `VOID.bat` e confirmar a execução como administrador.**

### 2. Download via Releases
Para uma experiência mais limpa, você pode baixar a versão estável diretamente na aba [Releases](https://github.com/DanTottem/VOID/releases). O arquivo `.zip` contém apenas o essencial para a execução.

---

## ⚙️ Uso Avançado (Terminal)
Caso prefira executar manualmente via PowerShell:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\VOID.ps1
