#!/usr/bin/env bash
# ==============================================================================
# Lenovo IdeaPad Duet 5 12IRU8 - Kamera Yaması & Fabrika Kalibrasyonu Kurulum Scripti
# ==============================================================================
set -e

if [ "$EUID" -ne 0 ]; then
  echo "[-] Bu script root yetkisi gerektirir. Lütfen 'sudo bash yukle.sh' ile çalıştırın."
  exit 1
fi

KVER=$(uname -r)
PATCH_DIR="/home/yavuz/duet5-camera"
UPDATE_DIR="/lib/modules/${KVER}/updates/duet5-camera"
HAL_DIR="/usr/share/defaults/etc/camera/ipu6ep"

echo "[1/5] Hedef dizin hazırlanıyor: ${UPDATE_DIR}..."
mkdir -p "${UPDATE_DIR}"
rm -f "${UPDATE_DIR}"/*

echo "[2/5] Yamalı ve derlenmiş modüller (CRC32 uyumlu) kopyalanıyor..."
cp -f "${PATCH_DIR}/int3472/intel_skl_int3472_common.ko.xz" "${UPDATE_DIR}/"
cp -f "${PATCH_DIR}/int3472/intel_skl_int3472_discrete.ko.xz" "${UPDATE_DIR}/"
cp -f "${PATCH_DIR}/ipu-bridge/ipu_bridge.ko.xz" "${UPDATE_DIR}/"
cp -f "${PATCH_DIR}/ov5675/ov5675.ko.xz" "${UPDATE_DIR}/"
cp -f "${PATCH_DIR}/gc5035/gc5035.ko.xz" "${UPDATE_DIR}/"

echo "[3/5] depmod -a çalıştırılıyor (öncelikli güncel modüller taranıyor)..."
depmod -a

echo "[4/5] Eski sensör ve güç modülleri bellekten boşaltılıp yenileri yükleniyor..."
modprobe -r gc5035 2>/dev/null || true
modprobe -r ov5675 2>/dev/null || true
modprobe -r intel_skl_int3472_discrete 2>/dev/null || true
modprobe -r intel_skl_int3472_common 2>/dev/null || true

modprobe intel_skl_int3472_common
modprobe intel_skl_int3472_discrete
modprobe ov5675
modprobe gc5035 2>/dev/null || true

echo "[5/5] Resmi fabrika kalibrasyon dosyaları ve renk profilleri kuruluyor..."

# 1. libcamera renk düzeltme ve kızılötesi sızıntı bastırma profili
if [ -f "${PATCH_DIR}/ov5675.yaml" ]; then
  echo "  [+] libcamera fabrika renk ve IR bastırma profili (/usr/share/libcamera/ipa/simple/ov5675.yaml) kuruluyor..."
  mkdir -p /usr/share/libcamera/ipa/simple
  cp -f "${PATCH_DIR}/ov5675.yaml" /usr/share/libcamera/ipa/simple/ov5675.yaml
fi

# 2. Intel IPU6 HAL resmi Windows fabrika dosyaları
if [ -d "${PATCH_DIR}/ipu6-hal-configs" ] && [ -d "${HAL_DIR}" ]; then
  echo "  [+] Intel IPU6 HAL resmi kalibrasyon dosyaları (${HAL_DIR}) kuruluyor..."
  cp -f "${PATCH_DIR}/ipu6-hal-configs"/*.aiqb "${HAL_DIR}/" 2>/dev/null || true
  cp -f "${PATCH_DIR}/ipu6-hal-configs"/*.cpf "${HAL_DIR}/" 2>/dev/null || true
  cp -f "${PATCH_DIR}/ipu6-hal-configs/gcss"/*.xml "${HAL_DIR}/gcss/" 2>/dev/null || true
  cp -f "${PATCH_DIR}/ipu6-hal-configs/sensors"/*.xml "${HAL_DIR}/sensors/" 2>/dev/null || true
  cp -f "${PATCH_DIR}/ipu6-hal-configs/libcamhal_profile.xml" "${HAL_DIR}/" 2>/dev/null || true
fi

# Eski takılı paylaşımlı bellek segmentini temizle
ipcrm -M 0x0043414d 2>/dev/null || true

echo ""
echo "=============================================================================="
echo "[+] TEBRİKLER! Yamalı modüller ve resmi fabrika kalibrasyonları yüklendi."
echo "=============================================================================="
echo ""
echo "Çekirdek günlüğündeki sensör ve IPU durumu:"
dmesg | grep -i -E "int3472|ov567|gcti|gc5035|ipu" | tail -n 30 || true
echo ""
echo "libcamera kameraları:"
cam -l 2>/dev/null || true
