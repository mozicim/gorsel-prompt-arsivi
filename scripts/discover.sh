#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
SOURCES_FILE="$SCRIPT_DIR/sources.txt"

# Taranacak GitHub topic'leri (aranan konu başlıkları)
TOPICS=(
  "image-prompt"
  "ai-image-prompts"
  "image-prompts"
  "prompt-collection"
  "gpt-image-2-prompts"
  "midjourney-prompts"
  "stable-diffusion-prompts"
)

MIN_STARS=20   # gürültüyü azaltmak için minimum yıldız eşiği
AUTH_HEADER=()
if [ -n "${GITHUB_TOKEN:-}" ]; then
  AUTH_HEADER=(-H "Authorization: Bearer $GITHUB_TOKEN")
fi

echo "Mevcut kaynaklar okunuyor..."
existing=$(grep -v '^#' "$SOURCES_FILE" | grep -v '^\s*$' || true)

new_found=0

for topic in "${TOPICS[@]}"; do
  echo "==> Topic taranıyor: $topic"
  url="https://api.github.com/search/repositories?q=topic:${topic}&sort=stars&order=desc&per_page=15"

  response=$(curl -s "${AUTH_HEADER[@]}" -H "Accept: application/vnd.github+json" "$url")

  # full_name ve stargazers_count alanlarını çek
  echo "$response" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
except Exception:
    sys.exit(0)
for item in data.get("items", []):
    print(f"{item[\"full_name\"]}|{item[\"stargazers_count\"]}|{item[\"html_url\"]}")
' | while IFS="|" read -r full_name stars html_url; do
    [ -z "$full_name" ] && continue
    if [ "$stars" -lt "$MIN_STARS" ]; then
      continue
    fi
    if echo "$existing" | grep -qF "$html_url"; then
      continue
    fi
    echo "  + Yeni bulundu: $full_name ($stars star)"
    {
      echo ""
      echo "# Otomatik keşif: $(date -u +%Y-%m-%d) | konu: $topic | $stars star"
      echo "$html_url"
    } >> "$SOURCES_FILE"
    new_found=$((new_found + 1))
  done

  sleep 2   # API rate limit'e takılmamak için
done

echo "Keşif tamamlandı."
