# 🧠 BRAIN-KÖPRÜ — duet5-camera & SecondBrain Çift Yönlü Entegrasyon

**Proje:** duet5-camera  
**Kasa (Vault) Konumu:** `/home/yavuz/SecondBrain`  
**Proje Konumu:** `/home/yavuz/duet5-camera`  
**İlgili SecondBrain Notları:**
* `[[knowledge/lenovo-ideapad-duet-5-linux-donanim-ve-kamera-yamasi]]`
* `[[knowledge/proje-dokumantasyon-standarti]]`
* `[[decisions/ADR-017-kanit-butunlugu-ve-denetim-kalibrasyonu]]`

---

## 1. Çift Yönlü Bilgi Akışı

```
/home/yavuz/SecondBrain/
  ├── knowledge/lenovo-ideapad-duet-5-linux-donanim-ve-kamera-yamasi.md  <--- Kalıcı özet ve donanım rehberi
  └── memory/active-context.md                                            <--- Oturum aktif durumu
         ▲
         │ (Senkronize)
         ▼
/home/yavuz/duet5-camera/
  ├── docs/
  │    ├── KURALLAR.md
  │    ├── KALDIGIMIZ_YER.md
  │    ├── plan/GENEL_PLAN.md
  │    └── ajan-hafizasi/
  └── [Kaynak Kodlar & Araçlar]
```

## 2. Kutsal İlkeler
1. **İskelet ≠ Bitti:** Bir donanım fonksiyonu sadece kod yazıldı diye bitti sayılmaz; dmesg çıktısı ve gerçek çerçeve akışı alınmadan bitti denilemez.
2. **Mock Yasağı:** Sensör sürücülerinde sahte I2C yanıtı verilemez; gerçek donanım ID'si (`0x5675`, `0x5035`) okunmalıdır.
3. **Senkronizasyon:** Projede bir modül çalıştığında veya yeni bir donanım keşfi yapıldığında hem `docs/` altındaki durum dosyaları hem de SecondBrain altındaki `knowledge/` belgesi güncellenir.
