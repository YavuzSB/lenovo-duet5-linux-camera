#!/usr/bin/env bash
# ==============================================================================
# Lenovo IdeaPad Duet 5 12IRU8 - Kamera Teşhis & Test Scripti
# ==============================================================================
echo "=== 1. Yüklü Modüller ==="
lsmod | grep -E "int3472|ov5675|ipu_bridge|gc5035|intel_ipu6"

echo ""
echo "=== 2. Hangi Modül Dosyaları Kullanımda? ==="
modinfo -n intel_skl_int3472_common
modinfo -n intel_skl_int3472_discrete
modinfo -n ipu_bridge
modinfo -n ov5675

echo ""
echo "=== 3. V4L2 Aygıt Listesi ==="
v4l2-ctl --list-devices

echo ""
echo "=== 4. libcamera Kamera Taraması ==="
cam -l

echo ""
echo "=== 5. Son Çekirdek Günlükleri (Sensör & IPU) ==="
journalctl -b -g "int3472|ov567|gcti|gc5035|ipu" --no-pager | tail -n 25
