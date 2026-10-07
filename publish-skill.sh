#!/usr/bin/env bash
# publish-skill.sh — собрать и опубликовать общие скиллы «Сибсенсор» в форк ai-native.
# Запуск из корня репозитория:  ./publish-skill.sh "описание изменения"
set -e
cd "$(dirname "$0")"
MSG="${1:-Обновление общих скиллов}"

PY="$(command -v python3 || true)"
[ -z "$PY" ] && { echo "Python 3 не найден"; exit 1; }
[ -d .venv ] || "$PY" -m venv .venv
VPY=.venv/bin/python

echo "== 1/3 Проверка скиллов =="
"$VPY" agent-platform/build_agent_plugins.py validate-skills
echo "== 2/3 Сборка плагинов =="
"$VPY" agent-platform/build_agent_plugins.py build-plugins --clean
echo "== 3/3 Проверка сборки =="
"$VPY" agent-platform/build_agent_plugins.py validate-generated

git checkout main
git pull --ff-only origin main
if [ -z "$(git status --porcelain)" ]; then echo "Изменений нет — публиковать нечего."; exit 0; fi
git add -A
git commit -m "$MSG"
git push origin main

echo "Готово. Скиллы опубликованы в main."
echo "Коллегам: обновить marketplace 'company-agent-skills' и плагин в Claude Code."
