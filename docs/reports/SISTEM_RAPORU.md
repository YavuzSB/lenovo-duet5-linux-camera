# 📊 DUET5-CAMERA SİSTEM VE GELİŞTİRME RAPORU

**Tarih:** 2026-10-15  
**Platform:** Lenovo IdeaPad Duet 5 12IRU8 / Fedora 44 Linux / Kernel 7.2.9  
**Raporlayan:** Antigravity Agent  

---

## 1. Yönetici Özeti
Lenovo IdeaPad Duet 5 12IRU8 üzerinde Linux altında çalışmayan dahili kameralar için kapsamlı bir çekirdek yaması ve donanım tersine mühendisliği gerçekleştirilmiştir.
* **Ön Kamera:** Başarıyla uyandırılmış, PipeWire ve libcamera üzerinde canlı akışa geçirilmiştir.
* **Windows Sürücü Analizi:** Lenovo resmi Windows 11 sürücüsü (`ogd5030fvkh82re0.exe`) ayıklanmış, sensörün Windows Hello için RGB-IR hibrit bir sensör olduğu ve siyah giysilerin yakın kızılötesi (NIR) yansıması nedeniyle kırmızı göründüğü tespit edilmiştir. Fabrika kalibrasyon verileri arşivlenmiştir.
* **Arka Kamera:** GalaxyCore GC5035 sensörünün güç ve saat bağlantıları incelenmektedir; mclk 19.2 MHz ve bağımsız GPIO desteği üzerine çalışılmaktadır.

---

## 2. Bileşen Durum Tablosu

| Bileşen | Durum | Açıklama |
|---|---|---|
| `intel_skl_int3472_discrete` | ✅ ÇALIŞIYOR | DVDD (0x08) ve 19.2MHz clock eklendi |
| `ipu_bridge` | ✅ ÇALIŞIYOR | OVTI5678 ve GCTI5035 sensörleri bağlandı |
| `ov5675` (Ön Sensör) | ✅ ÇALIŞIYOR | Powerdown GPIO desteği ile çip aktif edildi (`0x5675`) |
| `PipeWire / libcamera` | ✅ ÇALIŞIYOR | Masaüstü kamera düğümü aktif, Snapshot'ta akıyor |
| `gc5035` (Arka Sensör) | ⚠️ GELİŞTİRİLİYOR | I2C -121 hatası; mclk ve CJAK519 GPIO haritası üzerinde çalışılıyor |

---

## 3. Doğrulama Komutları
```bash
# Donanım ve medya çizgesi
media-ctl -p -d /dev/media0

# libcamera kullanılabilir kameralar
cam -l

# Çekirdek sensör günlüğü
dmesg | grep -i -E "gc5035|ov567|int3472" | tail -n 25
```
