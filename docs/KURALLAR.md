# 📜 duet5-camera — KURALLAR (AI Prompt & Geliştirici Kılavuzu)

> **Bu dosyayı yeni bir AI oturumuna prompt olarak ver.** AI bu dosyadaki kuralları ve okuma sırasını takip ederek hiçbir açıklama istemeden projenin kaldığı yerden devam eder.
> Ardından sırasıyla `docs/KALDIGIMIZ_YER.md` ve `docs/plan/GENEL_PLAN.md` okunur.

---

## 1. Proje Amacı ve Felsefesi

**duet5-camera** — Lenovo IdeaPad Duet 5 12IRU8 (Intel IPU6 Raptor Lake) Linux Kamera Sürücü ve Donanım Çözümü
- **Hedef:** Endüstriyel standartta, temiz, modüler ve test güvenceli geliştirme.
- **Teknoloji Yığını:** C, Linux Kernel Modules (int3472, ipu-bridge, ov5675, gc5035), Intel IPU6 HAL, libcamera, Bash

---

## 2. Geliştirici AI İçin Temel İlkeler

1. **Okuma Sırası Kutsaldır:**
   `KURALLAR.md` → `plan/GENEL_PLAN.md` → `KALDIGIMIZ_YER.md` → `BRAIN-KOPRU.md` → `ajan-hafizasi/DURUM.md` → `reports/SISTEM_RAPORU.md` → kod. Sırayı bozma, tahminle ilerleme.
2. **Kullanıcıya "Nerede Kaldık?" Sorma:**
   `docs/KALDIGIMIZ_YER.md` içindeki `Durum` ve `Sıradaki` başlıklarından doğrudan bağlamı al ve devam et.
3. **Tek Aktif Plan:**
   `docs/plan/GENEL_PLAN.md` tek nihai ve geçerli plandır.
4. **İskelet ≠ Bitti (AGENTS.md §7):**
   Yalnızca boş klasör veya arayüz tanımlayıp "bitti" demek yasaktır. Her faz gerçek çalışan kodlar, birim ve entegrasyon testleriyle tamamlanır. Mock veri kesinlikle yasaktır (kullanıcı açıkça onaylamadıkça).
5. **Kaldığımız Yeri Canlı Tut:**
   Her faz ve alt görev başında/sonunda `docs/KALDIGIMIZ_YER.md` güncellenir (`Son Güncelleme`, `Tamamlananlar`, `Şu An`, `Sıradaki`, `Test Kanıtı`).
6. **Test Kanıtı Olmadan İddia Yasaktır (AGENTS.md §8):**
   "Çalışıyor / bitti" demeden önce test ve derleme komutları çalıştırılır; geçen test sayısı kanıt olarak rapora işlenir.
7. **Raporla Birlikte Kapat:**
   Kodu güncelleyip raporları eski bırakma. İlgili `docs/reports/` dosyasını ve `docs/ajan-hafizasi/` notlarını eşzamanlı güncelle.
8. **Modüler Mimari (800 Satır Kuralı):**
   God object ve devasa tekil dosyalar yasaktır; modüler crate/paket ve servis ayrımı esastır.
9. **Kayıt Yenileme:**
   Her oturum başında raporları oku, oturum sonunda kayıtları güncelle. `docs/KALDIGIMIZ_YER.md` `Son Log` en fazla 3 satır tutulur.

---

## 3. Okuma Sırası (Yeni AI İçin)

1. **Bu dosya** (`docs/KURALLAR.md`)
2. `docs/plan/GENEL_PLAN.md` (Mimari şartname ve faz yol haritası)
3. `docs/KALDIGIMIZ_YER.md` (Anlık durum, bitti/kalan, sıradaki komutlar)
4. `docs/BRAIN-KOPRU.md` (SecondBrain köprüsü)
5. `docs/ajan-hafizasi/DURUM.md` ve `docs/ajan-hafizasi/DERSLER.md`
6. `docs/reports/SISTEM_RAPORU.md`
7. Kodlar

---

## 4. Çalışma Akışı

- **Başlarken:** `KALDIGIMIZ_YER.md` oku → `Sıradaki` işi al → ek soru sormadan geliştir.
- **Kodlarken:** Modülleri ve ilgili testleri paralel geliştir.
- **Bitirirken:**
  1. Testleri çalıştır ve kanıtı al.
  2. `docs/KALDIGIMIZ_YER.md` güncelle.
  3. `docs/reports/` altına faz raporunu ekle.
  4. Git commit at.

---
*Kaynak: `[[knowledge/proje-dokumantasyon-standarti]]`, `[[AGENTS.md]]` §7 & §8*
