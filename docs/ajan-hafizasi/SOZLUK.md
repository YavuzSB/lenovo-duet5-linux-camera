# 📖 AJAN HAFIZASI: TERİMLER SÖZLÜĞÜ

* **IPU6 (Intel Image Processing Unit 6):** Intel Tiger Lake, Alder Lake ve Raptor Lake işlemcilerde bulunan tümleşik kamera işlemcisi. İki alt birimi vardır: ISYS (Giriş alt sistemi / MIPI CSI-2 arayüzü) ve PSYS (İşleme alt sistemi / Donanım ISP).
* **MIPI CSI-2:** Kamera sensörlerinin işlemciye yüksek hızda doğrudan bağlandığı mobil kamera seri arayüzü.
* **INT3472:** Intel platformlarında kamera sensörlerinin güç regülatörlerini (AVDD, DVDD, DOVDD), saat sinyallerini (MCLK) ve GPIO pinlerini (Reset, Powerdown) yöneten ACPI güç denetleyicisi.
* **ipu-bridge:** Linux çekirdeğinde ACPI bilgilerini okuyarak IPU6 denetleyicisi ile kamera sensörleri arasında yazılımsal fwnode graft bağlantısını kuran köprü modülü.
* **RGB-IR:** Geleneksel Bayer filtresindeki (RGGB) bazı yeşil piksellerin yerine kızılötesi (I - Infrared) piksellerin yerleştirildiği hibrit sensör teknolojisi.
* **NIR (Near Infrared):** Yakın kızılötesi ışık (~850nm). İnsan gözüyle görünmez ancak silikon sensörler tarafından algılanır; siyah kumaşlar tarafından yüksek oranda yansıtılır.
* **AIQB (Algorithm Initial Quality Binary):** Intel IPU donanım ISP'si için renk düzeltme (CCM), beyaz dengesi (AWB), gürültü azaltma (NR) ve lens gölgeleme (LSC) parametrelerini içeren resmi ikili fabrika kalibrasyon dosyası.
* **CPF (Camera Parameter File):** Kamera sensör modülünün elektriksel ve optik parametrelerini tutan Intel formatı.
