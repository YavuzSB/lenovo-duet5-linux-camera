#!/usr/bin/env bash
# ==============================================================================
# Lenovo IdeaPad Duet 5 12IRU8 - Kamera Yaması Kaldırma (Rollback) Scripti
# ==============================================================================
set -e

if [ "$EUID" -ne 0 ]; then
  echo "[-] Bu script root yetkisi gerektirir. Lütfen 'sudo bash kaldir.sh' ile çalıştırın."
  exit 1
fi

KVER=$(uname -r)
UPDATE_DIR="/lib/modules/${KVER}/updates/duet5-camera"
HAL_DIR="/usr/share/defaults/etc/camera/ipu6ep"

echo "[1/4] Yamalı modül dizini siliniyor: ${UPDATE_DIR}..."
rm -rf "${UPDATE_DIR}"

echo "[2/4] Eklenen fabrika kalibrasyon ve profil dosyaları temizleniyor..."
rm -f /usr/share/libcamera/ipa/simple/ov5675.yaml
rm -f /usr/share/libcamera/ipa/simple/gc5035.yaml
rm -f "${HAL_DIR}/OV5678_CJFL515_ADL.aiqb" "${HAL_DIR}/OV5678_CJFL515_ADL.cpf"
rm -f "${HAL_DIR}/gc5035_CJAK519_ADL.aiqb" "${HAL_DIR}/gc5035_CJAK519_ADL.cpf"
rm -f "${HAL_DIR}/gcss/graph_settings_OV5678_CJFL515_ADL.xml"
rm -f "${HAL_DIR}/gcss/graph_settings_gc5035_CJAK519_ADL.xml"
rm -f "${HAL_DIR}/sensors/ov5675-uf.xml"

echo "[3/4] depmod -a çalıştırılarak orijinal Fedora çekirdek modüllerine dönülüyor..."
depmod -a

echo "[4/4] Servisler tazeleniyor..."
systemctl restart v4l2-relayd@icamerasrc.service 2>/dev/null || true

echo ""
echo "[+] Sistem başarıyla orijinal Fedora varsayılan ayarlarına döndürüldü."
