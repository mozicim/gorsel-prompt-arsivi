#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
SOURCES_FILE="$SCRIPT_DIR/sources.txt"

# Taranacak GitHub topic'leri (aranan konu basliklari)
TOPICS=(
  "image-prompt"
    "ai-image-prompts"
      "image-prompts"
        "prompt-collection"
          "gpt-image-2-prompts"
            "midjourney-prompts"
              "stable-diffusion-prompts"
              )

              MIN_STARS=20
              AUTH_HEADER=()
              if [ -n "${GITHUB_TOKEN:-}" ]; then
                AUTH_HEADER=(-H "Authorization: Bearer $GITHUB_TOKEN")
                fi

                echo "Mevcut kaynaklar okunuyor..."
                existing=$(grep -v '^#' "$SOURCES_FILE" | grep -v '^\s*$' || true)

                new_found=0

                for topic in "${TOPICS[@]}"; do
                  echo "==> Topic taraniyor: $topic"
                    url="https://api.github.com/search/repositories?q=topic:${topic}&sort=stars&order=desc&per_page=15"

                      response=$(curl -s "${AUTH_HEADER[@]}" -H "Accept: application/vnd.github+json" "$url")

                        echo "$response" | python3 "$SCRIPT_DIR/parse_repos.py" | while IFS="|" read -r full_name stars html_url; do
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
                                                                            echo "# Otomatik kesif: $(date -u +%Y-%m-%d) | konu: $topic | $stars star"
                                                                                  echo "$html_url"
                                                                                      } >> "$SOURCES_FILE"
                                                                                          new_found=$((new_found + 1))
                                                                                            done

                                                                                              sleep 2
                                                                                              done

                                                                                              echo "Kesif tamamlandi."
                                                                                              
