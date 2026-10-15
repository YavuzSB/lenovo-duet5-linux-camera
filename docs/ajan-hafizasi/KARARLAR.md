# ⚖️ AJAN HAFIZASI: ALINAN MİMARİ KARARLAR

| Karar ID | Tarih | Konu | Karar | Gerekçe |
|---|---|---|---|---|
| **KARAR-001** | 2026-10-15 | Ön Kamera Uyandırma | `ov5675.c` içine powerdown GPIO ve I2C recovery eklendi | ACPI tablosunda reset pini yok, çip uyku modunda kalıyordu |
| **KARAR-002** | 2026-10-15 | Modül Önceliği | `/lib/modules/$(uname -r)/updates/duet5-camera/` kullanıldı | Fedora'nın orijinal çekirdek paket dosyaları bozulmadan depmod önceliğiyle güvenli yama sağlandı |
| **KARAR-003** | 2026-10-15 | WirePlumber Yapılandırması | `50-disable-v4l2loopback.conf` ile loopback devredışı bırakıldı | WirePlumber'ın sahte döngü aygıtında `-4 not-negotiated` hatasıyla takılması önlendi |
| **KARAR-004** | 2026-10-15 | Fabrika Kalibrasyonları | Windows sürücüsü ayıklanıp `.aiqb` ve `.xml` dosyaları arşivlendi | Tersine mühendislikle tahminde bulunmak yerine üreticinin resmi parametreleri taban alındı |
| **KARAR-005** | 2026-10-15 | Ön Kamera / Arka Kamera Önceliği | Ön kamera renk ayarına ara verilip Arka Kamera (GC5035) aktive edilmesine geçildi | Kullanıcı talimatı: ön kamera zaten akıyor, arka kameranın da sisteme kazandırılması önceliklendirildi |
