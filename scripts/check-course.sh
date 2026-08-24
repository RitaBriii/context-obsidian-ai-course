#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."
failed=0

echo "1/4 Проверяем, что ученические шаблоны остались чистыми..."
if ! shasum -a 256 -c checks/clean-template-checksums.sha256; then
  echo
  echo "Один или несколько эталонных шаблонов изменены."
  echo "Проверьте, не попали ли в них личные ответы из тестового прохождения."
  echo "Если изменение было намеренным, после проверки обновите checks/clean-template-checksums.sha256."
  failed=1
fi

echo
echo "2/4 Ищем устаревшие названия и пути..."
if rg -n -i \
  'VS Code|vscode|CLAUDE\.md|03-command-memory|04-sources|05-full-session|handouts/03-command|handouts/04-sources|handouts/05-full' \
  --glob '*.md' \
  --glob '!my-work/**' \
  .; then
  echo
  echo "Найдены устаревшие упоминания старого сценария курса."
  failed=1
else
  echo "Устаревших упоминаний нет."
fi

echo
echo "3/4 Проверяем локальные Markdown-ссылки..."
if ! ruby scripts/check-markdown-links.rb; then
  failed=1
fi

echo
echo "4/4 Проверяем безопасную рабочую папку..."
if ! bash -n scripts/start-course.sh; then
  echo "В scripts/start-course.sh есть синтаксическая ошибка."
  failed=1
elif ! git check-ignore -q my-work/example.md; then
  echo "Папка my-work/ не исключена из Git."
  failed=1
else
  echo "Стартовый скрипт корректен, папка my-work/ исключена из Git."
fi

echo
if [[ "$failed" -ne 0 ]]; then
  echo "Проверка курса завершилась с ошибками."
  exit 1
fi

echo "Все проверки курса пройдены."
