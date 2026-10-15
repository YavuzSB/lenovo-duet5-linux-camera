# lenovo-duet5-linux-camera

> **Out-of-tree Linux kernel drivers, power sequencing patches, and factory image tuning profiles for the Lenovo IdeaPad Duet 5 12IRU8 (Intel IPU6 / Raptor Lake).**

[![Hardware: Lenovo IdeaPad Duet 5 12IRU8](https://img.shields.io/badge/Hardware-Lenovo%20IdeaPad%20Duet%205%2012IRU8-blue.svg)](https://psref.lenovo.com/)
[![Kernel: Linux 6.8+ / 7.x](https://img.shields.io/badge/Linux%20Kernel-6.8%2B%20%2F%207.x-green.svg)](https://kernel.org/)
[![Tested on Fedora 44](https://img.shields.io/badge/Tested%20On-Fedora%2044%20%2F%20GNOME%2050-informational.svg)](https://getfedora.org/)
[![Status: Fully Functional](https://img.shields.io/badge/Status-Front%20%26%20Rear%20Cameras%20Working-brightgreen.svg)]()
[![License: GPL-2.0 / CC0-1.0](https://img.shields.io/badge/License-GPL--2.0%20%2F%20CC0--1.0-orange.svg)]()

---

## 📌 Overview / Genel Bakış

The **Lenovo IdeaPad Duet 5 12IRU8** (Type `83B3`, `82TQ` — equipped with Intel 12th/13th Gen Core i5-1235U / i5-1335U Raptor Lake CPUs) is an exceptional 2-in-1 Windows tablet that runs Linux beautifully. However, on vanilla Linux distributions, **both built-in MIPI CSI-2 cameras fail to work out-of-the-box**:

1. **Front Camera (OmniVision OV5678 / `OVTI5678`):** Fails to power on due to missing INT3472 `DVDD` regulator definitions, active-low powerdown GPIO polarity mismatches, missing ACPI IDs, and missing IPU bridge bindings. Once forced on, black clothes appear glowing bright red/pink due to NIR (Near-Infrared) leakage on the hybrid RGB-IR sensor.
2. **Rear Camera (GalaxyCore GC5035 / `GCTI5035`):** Fails to probe with `-EREMOTEIO (-121)` due to unsequenced 3-rail PMIC supplies (`avdd`, `dovdd`, `dvdd`), 19.2 MHz CCF master clock (`mclk`) configuration issues, and inverted reset lines. Once active, images appear severely crushed, dark (7% brightness), and washed out due to libcamera defaulting to an uncalibrated profile.

This repository provides **all required patched kernel modules**, **proper hardware power sequencing**, **in-kernel CRC32-compressed `.ko.xz` binaries**, and **official factory color calibration profiles (CCM + NIR suppression + Black Level 64)** extracted from Lenovo's official Windows 11 drivers (`.aiqb`).

Both cameras work seamlessly with **GNOME Snapshot**, **Cheese**, **Firefox**, **Chrome**, **WebRTC**, **PipeWire / WirePlumber**, and **libcamera**.

---

## 🔬 Hardware Specifications

| Component | Hardware Identifier | Description / Role |
|---|---|---|
| **Platform** | Intel Raptor Lake-U (`8086:a75d`) | Intel IPU6EP (Image Processing Unit 6) |
| **Front Camera** | ACPI `OVTI5678` / OmniVision OV5678 | 5 MP MIPI CSI-2 Hybrid RGB-IR Sensor (Chicony D570 module) |
| **Rear Camera** | ACPI `GCTI5035` / GalaxyCore GC5035 | 5 MP MIPI CSI-2 Bayer Sensor (Chicony CJAK519 module) |
| **Camera PMIC** | ACPI `INT3472:01` & `INT3472:02` | Discrete PMIC providing `avdd` (2.8V), `dovdd` (1.8V), `dvdd` (1.2V), reset & powerdown GPIOs |
| **Clock Source** | Common Clock Framework (CCF) | 19.2 MHz `mclk` oscillator routed via INT3472 |
| **Display ALS** | `hid_sensor_als` | Ambient Light Sensor (auto-brightness override) |

---

## 🛠️ What This Repository Fixes

### 1. `intel_skl_int3472_discrete` & `common` (Power & Clock Delivery)
- **`DVDD (0x08)` Regulator Support:** Added `#define INT3472_GPIO_TYPE_DVDD 0x08` to recognize digital core voltage lines in Lenovo's ACPI tables.
- **Dynamic Clock Provider (`determine_rate` & `set_rate`):** Added CCF rate callback operations ensuring the 19.2 MHz sensor master clock (`mclk`) is locked without returning 0 Hz.
- **ACPI `_DEP` Fallback Scanner:** Ensures `INT3472:01` maps to `OVTI5678` and `INT3472:02` maps to `GCTI5035` even if upstream firmware drops dependency handles.

### 2. `ipu_bridge` (MIPI CSI-2 Sensor Matching)
- Registered `OVTI5678` (450 MHz link frequency) and `GCTI5035` (438 MHz link frequency) into `ipu_supported_sensors`, enabling the kernel to build software fwnode graph connections to `/dev/media0`.

### 3. `ov5675` (Front Camera & Powerdown Fix)
- Lenovo wires a hardware `POWERDOWN` pin instead of a `RESET` pin for the front camera. The upstream driver solely checked for `reset`, leaving the sensor powered down in hardware sleep. Added `powerdown_gpio` management and bound ACPI ID `OVTI5678`.

### 4. `gc5035` (Rear Camera `-EREMOTEIO` & Crop Fix)
- Hooked the 3 physical power rails (`avdd`, `dovdd`, `dvdd`), 19.2 MHz CCF clock, and active-low reset timing.
- Added V4L2 orientation (`V4L2_CAMERA_ORIENTATION_BACK`) and active pixel array crop geometry (`2592x1944`), eliminating libcamera warnings.

### 5. Factory Color Calibration & NIR Suppression (`ov5675.yaml` & `gc5035.yaml`)
- **NIR Leakage Fix (Front Camera):** Because the OV5678 lacks a physical IR-cut filter, near-infrared radiation causes synthetic black fabrics to fluoresce bright red. Using matrices extracted from Lenovo Windows driver `OV5678_CJFL515_ADL.aiqb`, we cancel NIR cross-talk across 6500K, 4000K, and 2850K illuminants.
- **Dynamic Range & Gamma Fix (Rear Camera):** Libcamera defaulted GC5035 to `uncalibrated.yaml` with linear gamma (1.0), crushing shadow detail to 7% brightness. We extracted factory Color Correction Matrices (CCM) from `gc5035_CJAK519_ADL.aiqb` and enabled a 64 black-level subtraction pedestal.

---

## 🚀 Quick Start (Kurulum)

### Prerequisites

Install kernel headers and build utilities for your distribution:

**Fedora / RHEL:**
```bash
sudo dnf install -y kernel-devel kernel-headers gcc make xz libcamera-tools
```

**Ubuntu / Debian:**
```bash
sudo apt install -y linux-headers-$(uname -r) build-essential libcamera-tools xz-utils
```

**Arch Linux:**
```bash
sudo pacman -S --needed linux-headers base-devel libcamera
```

### Installation

Clone the repository and run the installation script:

```bash
git clone https://github.com/<your-username>/lenovo-duet5-linux-camera.git
cd lenovo-duet5-linux-camera

# 1. Install patched modules & factory tuning profiles
sudo bash yukle.sh
```

*(Alternatively, run `make && sudo make install`)*

Once complete, open **GNOME Snapshot** or any camera application. You can switch between the front and rear cameras cleanly!

---

## 🧪 Verification & Diagnostics

To verify both cameras from the terminal:

```bash
# Check available cameras in libcamera
cam -l
```
*Expected output:*
```text
Available cameras:
1: Internal front camera (\_SB_.PC00.LNK0)
2: 'gc5035' (\_SB_.PC00.LNK1)
```

To run an automated health check:
```bash
bash test.sh
```

To capture a test frame from the rear camera:
```bash
cam -c 2 --capture=1 --file=test_rear_#.ppm
```

---

## 🔄 Building From Source (After Kernel Updates)

When your distribution updates the Linux kernel, recompile the modules against your new kernel:

```bash
cd lenovo-duet5-linux-camera

# Clean previous build artifacts
make clean

# Compile all 4 modules and compress with CRC32
make

# Install to updates/ directory and refresh system services
sudo make install
```

> [!IMPORTANT]
> The in-tree Linux kernel module decompressor strictly requires **CRC32** integrity checksums (`xz --check=crc32`). Modern CLI `xz` defaults to CRC64, which will result in `kernel: decompression failed with status 6`. The included `Makefile` automatically compresses with `--check=crc32`.

---

## 🧹 Uninstallation (Rollback)

If you ever wish to completely remove all patches and revert to stock distribution defaults:

```bash
sudo bash kaldir.sh
# Or: sudo make uninstall
```

This removes all out-of-tree `.ko.xz` modules from `/lib/modules/$(uname -r)/updates/duet5-camera`, deletes the custom libcamera profiles, runs `depmod -a`, and restores standard kernel module priority.

---

## 💡 Bonus: Screen Brightness & Ambient Light Sensor (ALS)

On GNOME (Wayland), the Ambient Light Sensor (`hid_sensor_als`) sits directly next to the front camera and continuously overrides your manual screen brightness slider. 

To disable automatic light sensor overrides while preserving tablet auto-rotation (accelerometer):

```bash
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
```

---

## 📂 Repository Structure

```text
lenovo-duet5-linux-camera/
├── int3472/             # INT3472 discrete PMIC & clock drivers (DVDD & fallback support)
├── ipu-bridge/          # IPU bridge table entries for OVTI5678 & GCTI5035
├── ov5675/              # OmniVision OV5675/OV5678 front camera driver (powerdown fix)
├── gc5035/              # GalaxyCore GC5035 rear camera driver (3-rail PMIC & V4L2 crop)
├── ov5675.yaml          # Libcamera tuning profile (NIR leakage cancellation & factory CCM)
├── gc5035.yaml          # Libcamera tuning profile (CCM & black level 64 pedestal)
├── ipu6-hal-configs/    # Official Lenovo Windows 11 factory calibration archives (.aiqb/.cpf)
├── Makefile             # Top-level build orchestration & CRC32 compression
├── yukle.sh             # Dynamic installation script with WirePlumber reload
├── kaldir.sh            # Safe uninstallation and distribution rollback script
├── test.sh              # Camera diagnostics & journalctl inspector
└── README.md            # This documentation
```

---

## 📄 License & Credits

- Kernel driver code is licensed under **GPL-2.0-only** in accordance with Linux kernel upstream licensing.
- Calibration profiles (`ov5675.yaml`, `gc5035.yaml`) and scripts are provided under **CC0-1.0** (Public Domain).
- Extracted calibration data originates from Lenovo official driver package `ogd5030fvkh82re0.exe` for IdeaPad Duet 5 12IRU8.
