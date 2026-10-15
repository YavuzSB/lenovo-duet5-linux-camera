# 📍 KALDIĞIMIZ YER — duet5-camera Anlık Durum

**Son Güncelleme:** 2026-10-15  
**Durum:** Faz 1 & Faz 2 TAMAMLANDI (Hem Ön Hem Arka Kamera Donanım Seviyesinde Aktif ve Çerçeve Yakalıyor)  
**Sıradaki İş:** **Masaüstü Arayüzü (Snapshot) Kamera Değiştirme ve Renk Kalibrasyonu**  
**Aktif Plan:** `docs/plan/GENEL_PLAN.md`  
**Test Kanıtı:** 
- `dmesg`: `SUCCESS! Detected GC5035 sensor (id=0x5035) on attempt 0!`
- `cam -l`:
  * `1: Internal front camera (\_SB_.PC00.LNK0)`
  * `2: 'gc5035' (\_SB_.PC00.LNK1)`
- `cam -c 2 --capture=1`: 2592x1944 20.4 MB tek kare başarıyla yakalandı.
- `pw-cli`:
  * `libcamera_input.__SB_.PC00.LNK0` (Ön Kamera)
  * `libcamera_input.__SB_.PC00.LNK1` (Arka Kamera)
**Git Durumu:** `master` güncel  

---

## ▶️ NASIL DEVAM EDİLİR (Kaldığın Yerden — Kopyala/Çalıştır)

```bash
cd /home/yavuz/duet5-camera

# 1) Modülleri yükle ve WirePlumber oturumunu tazele
sudo bash yukle.sh

# 2) Kameraları listele
cam -l

# 3) Arka kameradan test karesi yakala
cam -c 2 --capture=1

# 4) GNOME Snapshot uygulamasını başlat
snapshot
```

---

## ✅ ŞU AN ÇALIŞAN SİSTEM VE BİLEŞENLER

| Bileşen / Modül | Görevi / Durumu | Test Kanıtı |
|---|---|---|
| `ov5675.ko` | Ön kamera sürücüsü (`OVTI5678`) | `raw chip id: 0x5675` okundu |
| `gc5035.ko` | Arka kamera sürücüsü (`GCTI5035`) | `SUCCESS! Detected GC5035 sensor (id=0x5035)` |
| `intel_skl_int3472_discrete.ko` | PMIC güç hatları (avdd, dovdd, dvdd, reset) | 3 regülatör ve 19.2 MHz CCF saati aktif |
| `ipu_bridge.ko` | IPU6 fwnode sensör köprüsü | `/dev/media0` üzerinde her iki sensör bağlı |
| `PipeWire / WirePlumber` | Masaüstü kamera video düğümleri | `LNK0` (Ön) ve `LNK1` (Arka) Video/Source aktif |
| `libcamera` | Donanım boru hattı ve Soft-ISP | `cam -c 2 --capture=1` ile 2592x1944 kare yakalandı |
| `docs/` | Standart dokümantasyon ağacı | 5 temel direk eksiksiz kurulu |
| `ipu6-hal-configs/` | Resmi Windows fabrika kalibrasyonları | `.aiqb`, `.cpf`, `graph_settings_*.xml` arşivlendi |

---

## 📝 Son Log
- 2026-10-15: Ön kamera aktif edildi; Windows 11 fabrika kalibrasyonları ayıklandı.
- 2026-10-15: Arka kamera (GC5035) sürücüsü kökten çözüldü; regülatörler, 19.2MHz CCF saati, CRC32 çekirdek sıkıştırması ve donanım sekansı ile `0x5035` çip kimliği başarıyla okundu. `cam -c 2` ile 2592x1944 görüntü yakalandı.
- 2026-10-15 (20:40): `V4L2_CID_CAMERA_ORIENTATION` (BACK) ve `get_selection` crop hedefleri sürücüye eklendi; `yukle.sh` içine WirePlumber otomatik oturum tazelemesi yerleştirildi.
