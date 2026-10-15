# 🧭 duet5-camera GENEL MİMARİ PLANI

**Tarih:** 2026-10-15  
**Durum:** Faz 1 Tamamlandı (Ön Kamera Canlı), Faz 2 Aktif (Arka Kamera GC5035 Entegrasyonu)  
**Hedef Donanım:** Lenovo IdeaPad Duet 5 12IRU8 (Model 83B3, Intel Raptor Lake i5-1335U, IPU6EP `8086:a75d`)  
**İşletim Sistemi:** Fedora Linux 44 (Kernel 7.2.9-200.fc44.x86_64, GNOME Wayland)  

---

## 1. Goal (Hedef)
Lenovo IdeaPad Duet 5 12IRU8 hibrit tablet/laptop üzerindeki Intel IPU6 kamera alt sistemini (Ön OV5678 ve Arka GC5035 sensörleri) Linux çekirdeği, libcamera ve PipeWire üzerinde tam çalışır hale getirmek; resmi fabrika kalibrasyonlarını (`.aiqb`, `.cpf`, `graph_settings_*.xml`) entegre etmek ve kalıcı bir sürücü araç seti sunmak.

---

## 2. Success Criteria (Başarı Kriterleri)
1. **Ön Kamera (OVTI5678):** Çekirdek sürücüsü yüklenmeli, I2C üzerinden `0x5675` çip kimliği okunmalı, IPU6 köprüsü kurulmalı, `cam -l` ve PipeWire üzerinden GNOME Snapshot/WebRTC uygulamalarında görüntü akmalı.
2. **Arka Kamera (GCTI5035):** Çekirdek sürücüsü (`gc5035`) yüklenmeli, 19.2 MHz mclk ve bağımsız GPIO güç sıralaması (`CJAK519`) sağlanarak sensör çip kimliği başarıyla okunmalı (`Sensor ID check passed`), `/dev/media0` üzerine ikinci sensör olarak eklenmeli.
3. **Dokümantasyon & Bakım:** HukukAI & Autocore standartlarında 5 temel direkli `docs/` yapısı, git sürüm kontrolü ve tek komutla kurulum/kaldırma (`yukle.sh` / `kaldir.sh`).

---

## 3. Mevcut Durum ve Teknik Olgular
* **Ön Kamera (OmniVision OV5678):**
  * ACPI ID: `OVTI5678:00`.
  * Fiziksel Donanım: Windows Hello için kızılötesi destekli **RGB-IR Hibrit Sensör** (`bayer_order="GIGI_RGBG_GIGI_BGRG"`).
  * Fiziksel IR-Cut filtresi **YOKTUR**.
  * Çözüldü: Powerdown GPIO (0x01) yönetimi eklendi, çip uyandırıldı, PipeWire düğümü `libcamera_input.__SB_.PC00.LNK0` tescillendi.
  * Renk durumu: Fabrika AIQB matrisleri çıkarıldı; renk ince ayarına kullanıcı kararıyla ara verildi.
* **Arka Kamera (GalaxyCore GC5035):**
  * ACPI ID: `GCTI5035:00`.
  * Sensör: 5 MP CMOS Sensör (Bayer GRBG).
  * Mevcut Engel: `mclk rate set to 0 instead of requested 192000000`, `error -EREMOTEIO: Sensor ID check failed (error -121)`.
  * Kök Neden: Lenovo Duet 5 discrete int3472 tablosunda `CJAK519` modül kimliği ve bağımsız GPIO güç sıralaması (`use_independent_gpio: true`) eksik; mclk saat frekansı reddediliyor.

---

## 4. Mimari Faz Yol Haritası

### 🔹 Faz 1: Ön Kamera & Temel IPU6 Altyapısı (TAMAMLANDI)
* **1.1 int3472:** DVDD (0x08) regülatör desteği ve 19.2 MHz clock fallback eklendi.
* **1.2 ipu-bridge:** `OVTI5678` ve `GCTI5035` fwnode eşleşmeleri tanımlandı.
* **1.3 ov5675:** `powerdown` GPIO desteği eklendi, I2C çip kimliği `0x5675` doğrulandı.
* **1.4 PipeWire:** WirePlumber V4L2 loopback çakışması temizlendi, dahili kamera varsayılan yapıldı.
* **T1 Doğrulama:** `cam -c 1 --capture=1` ile 15 MB 5MP çerçeve yakalandı, Snapshot'ta canlı akış sağlandı.

### 🔹 Faz 2: Arka Kamera GC5035 Entegrasyonu (AKTİF HEDEF)
* **2.1 int3472 discrete modülü:** `CJAK519` sensör konfigürasyonu ve `use_independent_gpio` desteğinin eklenmesi.
* **2.2 mclk saat hattı:** GC5035 için 19.2 MHz sensör saat frekansının kilitlenmesi.
* **2.3 gc5035 sürücüsü:** Güç açma (power-on sequence), I2C adres doğrulama ve Sensör ID kontrolünün geçmesi (`0x5035`).
* **2.4 Medya Çizgesi:** `/dev/media0` üzerinde arka kamera CSI portunun bağlanması.
* **T1 Doğrulama:** `dmesg | grep gc5035` çıktısında `Sensor ID check failed` hatasının kaybolması, `cam -l` çıktısında 2 kameranın (`Internal front camera` ve `Internal rear camera`) listelenmesi.

### 🔹 Faz 3: Fabrika Kalibrasyonları ve Donanım ISP (BEKLEMEDE / İLERİ AŞAMA)
* **3.1 Intel HAL:** Windows'tan çıkarılan `OV5678_CJFL515_ADL.aiqb` ve `gc5035_CJAK519_ADL.aiqb` profillerinin donanım ISP'sinde (PSYS) doğrulanması.
* **3.2 libcamera Soft-ISP:** RGB-IR sızıntı çıkarma matrisinin kalibre edilmesi.

---

## 5. Doğrulama Kontrol Listesi

- [x] Ön kamera ACPI ve I2C iletişimi — Kontrol: `dmesg | grep "read raw chip id: 0x5675"`
- [x] Ön kamera PipeWire ve libcamera akışı — Kontrol: `cam -l`
- [ ] Arka kamera I2C Sensör ID doğrulaması — Kontrol: `dmesg | grep -i "gc5035"`
- [ ] Çift kamera listelenmesi — Kontrol: `cam -l` (Available cameras: 2)
