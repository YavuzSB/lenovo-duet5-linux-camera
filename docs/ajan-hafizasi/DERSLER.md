# 💡 AJAN HAFIZASI: DERSLER & TECRÜBELER

## 1. Lenovo ACPI Tablosundaki Gizli Tuzaklar
* **Powerdown vs Reset:** Upstream Linux çekirdeğindeki `ov5675` sürücüsü sadece `reset` GPIO arar. Ancak Lenovo ACPI DSDT tablosunda pin `0x01` (`POWERDOWN`) olarak işaretlenmiştir. Reset pinini aramak ve bulamamak sürücünün çipi sürekli uyku modunda tutmasına yol açar.
* **DVDD Regülatörü (0x08):** INT3472 discrete sürücüsü ACPI tablosunda `0x08` pin tipini varsayılan olarak desteklemez (`GPIO type 0x08 unknown`). Bu tipin DVDD (dijital çekirdek voltajı) olarak haritalanması zorunludur.

## 2. Windows Hello Kameraları ve RGB-IR Sensör Mimarisi
* Ön kamera (OV5678), karanlıkta yüz tanıma yapabilmek için fiziksel IR-Cut (Kızılötesi Kesici) filtreye sahip değildir.
* Bayer paterni klasik GRBG değil, `GIGI_RGBG_GIGI_BGRG` dizilimidir.
* Siyah giysiler görünür ışığı soğururken yakın kızılötesi (NIR) ışığı güçlü bir biçimde yansıtır.
* Standart Bayer demosaic algoritmaları bu kızılötesi ışığı Kırmızı (R) kanalına yükler ve siyah kumaşlar parlak kırmızı/pembe görünür.
* Windows bu sorunu Intel IPU6 PSYS donanım motorundaki RGB-IR ayırma matrisi (`.aiqb`) ile çözer; IR sinyali algılanıp R/G kanallarından matematiksel olarak düşülür.

## 3. WirePlumber & V4L2 Loopback Çakışması
* Sistemde boşta duran veya veri beslenmeyen bir `v4l2loopback` aygıtı varsa, WirePlumber kamerayı açarken bu aygıtla müzakere etmeye çalışıp `not-negotiated (-4)` hatasıyla kamerayı kilitleyebilir.
* Çözüm: WirePlumber yapılandırmasında sahte loopback aygıtını devre dışı bırakmak veya libcamera düğümünü birincil olarak atamaktır.
