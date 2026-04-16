@echo off
:: ─────────────────────────────────────────────
::  V.O.I.D. — Virtual Optimization & Internal Deletion — Launcher
::  Duplo clique para executar como Administrador
:: ─────────────────────────────────────────────

:: Verifica se já está rodando como Admin
net session >nul 2>&1
if %errorLevel% == 0 goto :run

:: Não está como Admin — relança elevado
echo Solicitando permissao de Administrador...
powershell -Command "Start-Process -FilePath '%~f0' -Verb RunAs"
exit /b

:run
:: Descobre o diretório onde este .bat está
set "DIR=%~dp0"

:: Executa o script PowerShell com política de execução liberada
powershell -NoProfile -ExecutionPolicy Bypass -File "%DIR%VOID.ps1"

pause
