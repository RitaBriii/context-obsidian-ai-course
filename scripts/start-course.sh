#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.."

workspace="my-work"

copy_if_missing() {
  source_file="$1"
  target_file="$2"

  mkdir -p "$(dirname "$target_file")"

  if [[ -e "$target_file" ]]; then
    echo "Сохраняем существующий файл: $target_file"
    return
  fi

  cp "$source_file" "$target_file"
  echo "Создан файл: $target_file"
}

echo "Подготавливаем личную рабочую папку курса..."
echo

copy_if_missing "student-work/progress.md" "$workspace/student-work/progress.md"
copy_if_missing "student-work/session-log.md" "$workspace/student-work/session-log.md"
copy_if_missing "student-work/vault-plan.md" "$workspace/student-work/vault-plan.md"

copy_if_missing "exercises/01-context-map/context-map.md" "$workspace/exercises/01-context-map/context-map.md"
copy_if_missing "exercises/01-context-map/checkpoint.md" "$workspace/exercises/01-context-map/checkpoint.md"
copy_if_missing "exercises/02-obsidian-vault/checkpoint.md" "$workspace/exercises/02-obsidian-vault/checkpoint.md"
copy_if_missing "exercises/03-configs-and-instructions/assistant-config-template.md" "$workspace/exercises/03-configs-and-instructions/assistant-config-template.md"
copy_if_missing "exercises/03-configs-and-instructions/checkpoint.md" "$workspace/exercises/03-configs-and-instructions/checkpoint.md"
copy_if_missing "exercises/04-command-memory/command-template.md" "$workspace/exercises/04-command-memory/command-template.md"
copy_if_missing "exercises/04-command-memory/checkpoint.md" "$workspace/exercises/04-command-memory/checkpoint.md"
copy_if_missing "exercises/05-sources/source-template.md" "$workspace/exercises/05-sources/source-template.md"
copy_if_missing "exercises/05-sources/checkpoint.md" "$workspace/exercises/05-sources/checkpoint.md"
copy_if_missing "exercises/06-full-session/session-brief.md" "$workspace/exercises/06-full-session/session-brief.md"
copy_if_missing "exercises/06-full-session/session-retrospective.md" "$workspace/exercises/06-full-session/session-retrospective.md"
copy_if_missing "exercises/06-full-session/checkpoint.md" "$workspace/exercises/06-full-session/checkpoint.md"

while IFS= read -r source_file; do
  relative_path="${source_file#templates/obsidian-vault/}"
  copy_if_missing "$source_file" "$workspace/obsidian-vault/$relative_path"
done < <(find templates/obsidian-vault -type f ! -name ".gitkeep" | sort)

echo
echo "Личная рабочая папка готова."
echo "Прогресс: my-work/student-work/progress.md"
echo "Упражнения: my-work/exercises/"
echo "Obsidian vault: my-work/obsidian-vault/"
echo
echo "Повторный запуск безопасен: существующие ответы не перезаписываются."
