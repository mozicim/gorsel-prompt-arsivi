#!/usr/bin/env bash
set -euo pipefail

SOURCES_FILE="$(dirname "$0")/sources.txt"
TARGET_ROOT="$(dirname "$0")/../repos"
mkdir -p "$TARGET_ROOT"

while IFS= read -r url; do
  # Boş satırları ve yorumları atla
  [[ -z "$url" || "$url" =~ ^# ]] && continue

  repo_name=$(basename "$url" .git)
  owner_name=$(basename "$(dirname "$url")")
  dest="$TARGET_ROOT/${owner_name}__${repo_name}"

  echo "==> $url senkronize ediliyor -> $dest"

  if [ -d "$dest" ]; then
    rm -rf "$dest"
  fi

  git clone --depth 1 "$url" "$dest" 2>&1 | grep -v "Cloning into" || true
  rm -rf "$dest/.git"

  # Her repo klasörüne kaynağı ve tarihi not düş
  {
    echo "Kaynak: $url"
    echo "Son senkronizasyon: $(date -u +"%Y-%m-%d %H:%M UTC")"
  } > "$dest/_SYNC_INFO.txt"

done < "$SOURCES_FILE"

echo "Tüm kaynaklar senkronize edildi."
