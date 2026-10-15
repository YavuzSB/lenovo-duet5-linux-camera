# 📍 KALDIĞIMIZ YER — duet5-camera Anlık Durum

**Son Güncelleme:** 2026-10-15  
**Durum:** Faz 1 Tamamlandı (Ön Kamera Canlı), Faz 2 Aktif (Arka Kamera GC5035 Entegrasyonu)  
**Sıradaki İş:** **Faz 2: Arka Kamera GC5035 Sürücüsünü ve Güç/Saat Sıralamasını Çözmek**  
**Aktif Plan:** `docs/plan/GENEL_PLAN.md`  
**Test Kanıtı:** `cam -l` -> `1: Internal front camera (\_SB_.PC00.LNK0)` aktif; arka kamera `-EREMOTEIO (-121)`  
**Git Durumu:** İlklendirildi (`master`)  

---

## ▶️ NASIL DEVAM EDİLİR (Kaldığın Yerden — Kopyala/Çalıştır)

```bash
cd /home/yavuz/duet5-camera

# 1) Mevcut durumu denetle
bash test.sh

# 2) Çekirdek günlüğündeki sensör hatalarını oku
dmesg | grep -i -E "gc5035|gcti|ov567|int3472" | tail -n 30

# 3) Yamalı modülleri derle ve kur
sudo bash yukle.sh
```

---

## ✅ ŞU AN ÇALIŞAN SİSTEM VE BİLEŞENLER

| Bileşen / Modül | Görevi / Durumu | Test Kanıtı |
|---|---|---|
| `ov5675.ko` | Ön kamera sürücüsü (`OVTI5678`) | `raw chip id: 0x5675` okundu |
| `intel_skl_int3472_discrete.ko` | Ön kamera powerdown ve regülatör kontrolü | DVDD regülatörü ve GPIO eşleşti |
| `ipu_bridge.ko` | IPU6 fwnode sensör köprüsü | `/dev/media0` üzerinde ov5675 entity 233 bağlandı |
| `PipeWire / WirePlumber` | Masaüstü kamera video düğümü | `libcamera_input.__SB_.PC00.LNK0` tescillendi |
| `GNOME Snapshot` | Kamera arayüzü | Ön kamera canlı akış sağlıyor |
| `docs/` | Standart dokümantasyon ağacı | 5 temel direk eksiksiz kurulu |
| `ipu6-hal-configs/` | Resmi Windows fabrika kalibrasyonları | `.aiqb`, `.cpf`, `graph_settings_*.xml` arşivlendi |

---

## 🎯 SIRADAKİ İŞ: FAZ 2 (ARKA KAMERA GC5035)

1. **mclk Saat Problemi:** `mclk rate set to 0 instead of requested 192000000` uyarısını gidermek (`clk_and_regulator.c` içinde GC5035 için 19.2 MHz saat sağlama).
2. **Discrete Bağımsız GPIO Haritası:** Windows INF ve upstream ADL-M yaması (`0001-Add-the-camera-sensor-gc5035-to-support-ADL-M.patch`) doğrultusunda `discrete.c` içine `CJAK519` modülünü bağımsız GPIO modunda (`use_independent_gpio: true`) eklemek.
3. **Sensor ID Doğrulaması:** `gc5035_check_sensor_id` fonksiyonunun başarıyla `0x5035` okumasını sağlamak.
4. **Medya Çizgesi Doğrulaması:** `cam -l` çıktısında 2 kameranın birden görünmesini sağlamak.

---

## 📝 Son Log
- 2026-10-15: Ön kamera aktif edildi; Windows 11 fabrika kalibrasyonları (`OV5678_CJFL515_ADL.aiqb`) ayıklanıp arşivlendi; ön kamera renk ayarına ara verilip arka kamera (GC5035) hedefine geçildi. Standart `docs/` ağacı kuruldu.
