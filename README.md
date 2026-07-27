# Görsel Prompt Arşivi

Bu repo her 3 günde bir otomatik olarak:
1. GitHub'da image-prompt / ai-image-prompts / prompt-collection gibi
   konu başlıklarını tarayıp yeni ve popüler repoları **keşfeder**
   (`scripts/discover.sh`) ve `scripts/sources.txt`'e ekler,
2. Listedeki tüm repoları çekip `repos/` klasörüne **mirror'lar**
   (`scripts/sync.sh`).

Yani listeyi elle büyütmene gerek yok — sistem kendi kendine yeni kaynak
bulup ekliyor, sen sadece sonuçları `repos/` altında görüyorsun.

## Kurulum

1. GitHub'da yeni, boş bir repo oluştur (örn. `gorsel-prompt-arsivi`).
2. Bu klasördeki tüm dosyaları (`.github/`, `scripts/`, `README.md`) o reponun
   köküne yükle (git push veya web arayüzünden "upload files").
3. Repo ayarlarından **Settings > Actions > General > Workflow permissions**
   kısmında "Read and write permissions" seçili olduğundan emin ol.
   (Actions'ın kendi reponuza commit/push atabilmesi için gerekli.)
4. Bu kadar — ekstra token/secret eklemene gerek yok, GitHub'ın kendi
   otomatik `GITHUB_TOKEN`'ı yeterli.

## Yeni kaynak eklemek

Otomatik keşif zaten her çalıştığında yeni repoları bulup ekliyor
(minimum 20 star eşiği ile). İstersen sen de elle `scripts/sources.txt`
dosyasına bir satır olarak repo linkini ekleyebilirsin:

```
https://github.com/kullanici/repo-adi
```

Taranan konu başlıklarını değiştirmek istersen `scripts/discover.sh`
içindeki `TOPICS` listesini düzenle.

## Elle çalıştırmak

Actions sekmesinden "Görsel Prompt Arşivi - Otomatik Senkronizasyon"
workflow'unu seçip "Run workflow" ile 3 gün beklemeden anında tetikleyebilirsin.

## Not

- Her senkronizasyonda ilgili repo klasörü tamamen silinip yeniden klonlanır,
  yani hep en güncel hali durur.
- Git geçmişi (`.git`) taşınmaz, sadece dosya içeriği kopyalanır — bu yüzden
  "mirror" değil "snapshot/clone" mantığıyla çalışır.
