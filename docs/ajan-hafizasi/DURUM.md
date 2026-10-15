# 📌 AJAN HAFIZASI: DURUM

**Son Güncelleme:** 2026-10-15 19:10  
**Aktif Ajan Görevi:** Faz 2 (Arka Kamera GC5035 Entegrasyonu)  

---

## 1. Donanım Özeti
* **Cihaz:** Lenovo IdeaPad Duet 5 12IRU8 (Type 83B3)
* **İşlemci:** Intel Core i5-1335U (Raptor Lake, 10 Core / 12 Thread)
* **IPU:** Intel IPU6EP (`8086:a75d`)
* **Ön Sensör:** OmniVision OV5678 (ACPI: `OVTI5678`, I2C bus 3-0036) -> ÇALIŞIYOR
* **Arka Sensör:** GalaxyCore GC5035 (ACPI: `GCTI5035`, I2C bus GCTI5035:00) -> BAĞLANTI HATASI (-121)

---

## 2. Modül ve Sürücü Durumu
* `intel_skl_int3472_common.ko`: Yüklü (Yamalı)
* `intel_skl_int3472_discrete.ko`: Yüklü (Yamalı: DVDD 0x08 desteği ve 19.2MHz clock)
* `ipu_bridge.ko`: Yüklü (Yamalı: OVTI5678 ve GCTI5035 fwnode graft)
* `ov5675.ko`: Yüklü (Yamalı: powerdown GPIO desteği)
* `gc5035.ko`: Yüklü (Upstream / Extra, henüz yamalanmadı, -121 EREMOTEIO hatası veriyor)

---

## 3. Açık Problemler & Takip
* **Problem 1 (Arka Kamera):** `gc5035 i2c-GCTI5035:00: error -EREMOTEIO: Sensor ID check failed (-121)`.
  * *İlerleme:* Windows sürücüsünde modülün `CJAK519` olduğu, bağımsız GPIO modunda çalıştığı ve 19.2 MHz saat istediği belirlendi.
* **Problem 2 (Ön Kamera Renk Dengeleme):** Ön kamera fiziksel IR-Cut filtresiz bir RGB-IR hibrit sensör olduğu için siyah kumaşlarda yakın kızılötesi sızıntısı var.
  * *İlerleme:* Windows fabrika AIQB dosyası ayıklandı, renk matrisleri çıkarıldı; kullanıcı kararıyla arka kamera bitene kadar ara verildi.
