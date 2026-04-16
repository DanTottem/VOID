#Requires -RunAsAdministrator
<#
.SYNOPSIS
    V.O.I.D. - Virtual Optimization & Internal Deletion
.DESCRIPTION
    Script otimizado para limpeza de cache e arquivos temporarios, incluindo lixeira.
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'SilentlyContinue'

# --------------------------------------------------------------
#  PALETA DE CORES
# --------------------------------------------------------------
$ESC = [char]27
$C = @{
    Reset   = "$ESC[0m"
    Bold    = "$ESC[1m"
    Cyan    = "$ESC[96m"
    Green   = "$ESC[92m"
    Yellow  = "$ESC[93m"
    Red     = "$ESC[91m"
    Magenta = "$ESC[95m"
    Gray    = "$ESC[90m"
    White   = "$ESC[97m"
    BgBlue  = "$ESC[44m"
}

# --------------------------------------------------------------
#  FUNCOES AUXILIARES
# --------------------------------------------------------------
function Format-Size {
    param([double]$Bytes)
    if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return "{0:N2} KB" -f ($Bytes / 1KB) }
    return "{0} B" -f $Bytes
}

function Get-DirectorySize {
    param([string[]]$Paths)
    $total = 0
    foreach ($p in $Paths) {
        if (Test-Path $p) {
            try {
                $size = (Get-ChildItem -Path $p -Recurse -File -Force -ErrorAction SilentlyContinue |
                         Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum
                $total += if ($null -ne $size) { $size } else { 0 }
            } catch { }
        }
    }
    return $total
}

function Get-RecycleBinSize {
    $size = 0
    try {
        $shell = New-Object -ComObject Shell.Application
        $rb = $shell.Namespace(0xA)
        foreach ($item in $rb.Items()) { try { $size += $item.Size } catch { } }
        [System.Runtime.InteropServices.Marshal]::ReleaseComObject($shell) | Out-Null
    } catch { }
    return $size
}

function Remove-FilesWithReport {
    param([string[]]$Paths, [string]$Category)
    $beforeBytes = 0; $removedBytes = 0; $skippedBytes = 0
    
    if ($Category -eq "Lixeira") {
        $beforeBytes = Get-RecycleBinSize
        try {
            Clear-RecycleBin -Force -ErrorAction Stop
            $removedBytes = $beforeBytes
        } catch { $skippedBytes = $beforeBytes }
    } else {
        $allFiles = @()
        foreach ($p in $Paths) {
            if (Test-Path $p) { $allFiles += Get-ChildItem -Path $p -Recurse -File -Force -ErrorAction SilentlyContinue }
        }
        $total = $allFiles.Count; $i = 0
        foreach ($file in $allFiles) {
            $i++; $beforeBytes += $file.Length
            if ($total -gt 0) {
                Write-Progress -Activity "Limpando $Category" -Status "Processando $i de $total" -PercentComplete ([int](($i/$total)*100)) -Id 2 -ParentId 1
            }
            try {
                Remove-Item -Path $file.FullName -Force -ErrorAction Stop
                $removedBytes += $file.Length
            } catch { $skippedBytes += $file.Length }
        }
    }
    return [PSCustomObject]@{ Category=$Category; BeforeBytes=$beforeBytes; RemovedBytes=$removedBytes; SkippedBytes=$skippedBytes }
}

# --------------------------------------------------------------
#  CABECALHO
# --------------------------------------------------------------
function Show-Header {
    Clear-Host
    Write-Host "`n  $($C.Cyan)$($C.Bold)VOID (Virtual Optimization & Internal Deletion)$($C.Reset)"
    Write-Host "  $($C.Gray)------------------------------------------------------------------------$($C.Reset)"
}

function Confirm-Action {
    Write-Host "  $($C.Yellow)! Este script removera arquivos temporarios e de cache do sistema.$($C.Reset)"
    Write-Host "  $($C.Gray)  Arquivos em uso serao ignorados automaticamente.`n$($C.Reset)"
    $resp = Read-Host "  Deseja continuar? [S/N]"
    if ($resp -notmatch '^[Ss]$') { exit 0 }
    Write-Host ""
}

# --------------------------------------------------------------
#  ALVOS E EXECUCAO
# --------------------------------------------------------------
$targets = [ordered]@{
    "Temporarios Usuario" = @($env:TEMP, "$env:LOCALAPPDATA\Temp")
    "Temporarios Sistema" = @("C:\Windows\Temp")
    "Prefetch"            = @("C:\Windows\Prefetch")
    "Shaders NVIDIA"      = @("$env:LOCALAPPDATA\NVIDIA\DXCache", "$env:LOCALAPPDATA\NVIDIA Corporation\NV_Cache")
    "Shaders DirectX"     = @("$env:LOCALAPPDATA\Microsoft\DirectX Shader Cache")
    "Logs de Sistema"     = @("C:\Windows\Logs", "C:\Windows\SoftwareDistribution\Download")
    "Lixeira"             = @()
}

Show-Header
Confirm-Action

Write-Host "  $($C.Bold)$($C.White)[ PRE-ANALISE ] Calculando espaco...$($C.Reset)"
$totalBefore = 0
foreach ($name in $targets.Keys) {
    $size = if ($name -eq "Lixeira") { Get-RecycleBinSize } else { Get-DirectorySize -Paths $targets[$name] }
    $totalBefore += $size
    Write-Host "  > $name : $(Format-Size $size)"
}

Write-Host "`n  $($C.Bold)$($C.White)[ INICIANDO LIMPEZA ]$($C.Reset)`n"
$results = New-Object System.Collections.Generic.List[PSCustomObject]
$step = 0

foreach ($name in $targets.Keys) {
    $step++
    Write-Progress -Activity "Executando V.O.I.D." -Status "Limpando $name" -PercentComplete ([int](($step/$targets.Count)*100)) -Id 1
    $r = Remove-FilesWithReport -Paths $targets[$name] -Category $name
    $results.Add($r)
}

# --------------------------------------------------------------
#  RELATORIO FINAL
# --------------------------------------------------------------
$totalRemoved = ($results | Measure-Object -Property RemovedBytes -Sum).Sum
$pct = if ($totalBefore -gt 0) { [int](($totalRemoved / $totalBefore) * 100) } else { 0 }

Write-Host "  $($C.Gray)------------------------------------------------------------------------$($C.Reset)"
Write-Host "  $($C.BgBlue)$($C.Bold)$($C.White) OK - TOTAL LIBERADO: $(Format-Size $totalRemoved) ($pct por cento) $($C.Reset)"
Write-Host "  $($C.Gray)------------------------------------------------------------------------$($C.Reset)"
Write-Host "  $($C.Gray)Concluido em $(Get-Date -Format 'dd-MM-yyyy HH:mm:ss')$($C.Reset)`n"

Read-Host "  Pressione ENTER para sair"