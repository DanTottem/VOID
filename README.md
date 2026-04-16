# 🌌 V.O.I.D. — Virtual Optimization & Internal Deletion

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
> **Aviso para usuários AMD:** O script vem configurado nativamente para NVIDIA. Se você utiliza uma placa de vídeo **AMD**, você mesmo pode realizar as mudanças no código para incluir os caminhos de cache específicos da marca (geralmente localizados em `%LocalAppData%\AMD\DxCache`). O código é modular e fácil de adaptar!

---

## 🛠️ Como Utilizar

O V.O.I.D. foi desenhado para ser prático. Existem duas formas principais de execução:

### 1. Execução via Arquivo .bat (Recomendado)
Para maior praticidade, você pode executar o programa usando um arquivo **.bat**. Isso automatiza a elevação de privilégios e ignora restrições de política do PowerShell.
* Crie um arquivo chamado `Limpar.bat` na mesma pasta do script.
* Cole o código abaixo:
```batch
@echo off
title Executando V.O.I.D.
:: Força a execução como Administrador e ignora política de execução
PowerShell -NoProfile -ExecutionPolicy Bypass -File "%~dp0VOID.ps1"
pause
