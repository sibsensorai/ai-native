<#
  publish-skill.ps1 — собрать и опубликовать общие скиллы «Сибсенсор» в форк ai-native.
  Запуск из корня репозитория:
      .\publish-skill.ps1 "короткое описание изменения"
#>
param([string]$Message = "Обновление общих скиллов")
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

# --- Python / venv ---
$py = "$env:LOCALAPPDATA\Programs\Python\Python312\python.exe"
if (-not (Test-Path $py)) { $c = Get-Command python.exe -ErrorAction SilentlyContinue; if ($c) { $py = $c.Source } }
if (-not $py) { throw "Python 3 не найден. Установите Python и повторите." }
if (-not (Test-Path ".\.venv\Scripts\python.exe")) { & $py -m venv .venv }
$vpy = ".\.venv\Scripts\python.exe"

Write-Host "== 1/3 Проверка скиллов ==" -ForegroundColor Cyan
& $vpy agent-platform/build_agent_plugins.py validate-skills
Write-Host "== 2/3 Сборка плагинов ==" -ForegroundColor Cyan
& $vpy agent-platform/build_agent_plugins.py build-plugins --clean
Write-Host "== 3/3 Проверка сборки ==" -ForegroundColor Cyan
& $vpy agent-platform/build_agent_plugins.py validate-generated

# --- Публикация в main ---
$env:Path = "C:\Program Files\Git\cmd;" + $env:Path
git checkout main
git pull --ff-only origin main
$changes = git status --porcelain
if (-not $changes) { Write-Host "Изменений нет — публиковать нечего." -ForegroundColor Yellow; exit 0 }
git add -A
git commit -m $Message
git push origin main

Write-Host ""
Write-Host "Готово. Скиллы опубликованы в main." -ForegroundColor Green
Write-Host "Коллегам: в Claude Code обновить marketplace 'company-agent-skills' и обновить плагин (/plugin -> Code)."
