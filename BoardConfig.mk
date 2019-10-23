#
# Copyright (C) 2019 The MoKee Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BOARD_VENDOR := smartisan

DEVICE_PATH := device/smartisan/trident

# Build
BUILD_BROKEN_DUP_RULES := true
PRODUCT_SOONG_NAMESPACES += $(DEVICE_PATH)

# Bootloader
TARGET_BOOTLOADER_BOARD_NAME := sdm845
TARGET_NO_BOOTLOADER := true

# Platform
TARGET_BOARD_PLATFORM := sdm845
TARGET_BOARD_PLATFORM_GPU := qcom-adreno630

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := kryo385

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-2a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := kryo385

TARGET_USES_64_BIT_BINDER := true

# Kernel
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_CMDLINE := androidboot.hardware=qcom androidboot.console=ttyMSM0 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 service_locator.enable=1 swiotlb=2048 androidboot.configfs=true androidboot.usbcontroller=a600000.dwc3 printk.devkmsg=on sysrq_always_enabled
BOARD_KERNEL_CMDLINE += androidboot.avb_version=1.0
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_TAGS_OFFSET := 0x00000100
BOARD_RAMDISK_OFFSET := 0x01000000
BOARD_KERNEL_IMAGE_NAME := Image.gz-dtb
BOARD_KERNEL_SEPARATED_DTBO := true

TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/smartisan/sdm845
TARGET_KERNEL_CONFIG := mokee_trident_defconfig

NEED_KERNEL_MODULE_SYSTEM := true

# HAX: SELinux Permissive - Remove ASAP
BOARD_KERNEL_CMDLINE += androidboot.selinux=permissive

# A/B
AB_OTA_UPDATER := true

AB_OTA_PARTITIONS += \
    boot \
    dtbo \
    system \
    vendor \
    vbmeta

# Audio
USE_DEVICE_SPECIFIC_AUDIO := true
USE_XML_AUDIO_POLICY_CONF := 1

# Bluetooth
BOARD_BLUETOOTH_BDROID_BUILDCFG_INCLUDE_DIR := $(DEVICE_PATH)/bluetooth

# Camera
USE_DEVICE_SPECIFIC_CAMERA := true
USE_CAMERA_STUB := true
BOARD_QTI_CAMERA_32BIT_ONLY := true
TARGET_USES_QTI_CAMERA_DEVICE := true
TARGET_USES_QTI_CAMERA2CLIENT := true
TARGET_LD_SHIM_LIBS += /vendor/lib/libmms_hal_vstab.so|/vendor/lib/libshim_camera.so
TARGET_LD_SHIM_LIBS += /vendor/lib/libmms_warper_vstab.so|/vendor/lib/libshim_camera.so

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true
BOARD_CHARGER_DISABLE_INIT_BLANK := true
WITH_MOKEE_CHARGER := false

# Display
TARGET_FORCE_HWC_FOR_VIRTUAL_DISPLAYS := true
TARGET_USES_C2D_COMPOSITION := true
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC1 := true
TARGET_USES_ION := true
TARGET_USES_NEW_ION_API :=true
TARGET_USES_OVERLAY := true
TARGET_USES_COLOR_METADATA := true
TARGET_CONTINUOUS_SPLASH_ENABLED := true
USE_OPENGL_RENDERER := true
NUM_FRAMEBUFFER_SURFACE_BUFFERS := 2

# Filesystem
TARGET_FS_CONFIG_GEN := $(DEVICE_PATH)/config.fs

# GPS
USE_DEVICE_SPECIFIC_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := $(TARGET_BOARD_PLATFORM)

# HIDL
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/compatibility_matrix.xml

# Lights
TARGET_PROVIDES_LIBLIGHT := true

# Media
USE_DEVICE_SPECIFIC_MEDIA := true
TARGET_USES_MEDIA_EXTENSIONS := true

# NFC
PRODUCT_SOONG_NAMESPACES += vendor/nxp/opensource/pn5xx

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 2998927360
BOARD_VENDORIMAGE_PARTITION_SIZE := 524288000
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_FLASH_BLOCK_SIZE := 262144 # (BOARD_KERNEL_PAGESIZE * 64)
TARGET_COPY_OUT_VENDOR := vendor

# Properties
BOARD_PROPERTY_OVERRIDES_SPLIT_ENABLED := true
TARGET_SYSTEM_PROP := $(DEVICE_PATH)/system.prop $(DEVICE_PATH)/system_tident.prop

# QCOM
BOARD_USES_QCOM_HARDWARE := true
BUILD_WITHOUT_VENDOR := true

# Recovery
BOARD_USES_RECOVERY_AS_BOOT := true
TARGET_NO_RECOVERY := true
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_USES_MKE2FS := true

# Root
BOARD_BUILD_SYSTEM_ROOT_IMAGE := true
BOARD_ROOT_EXTRA_FOLDERS := persist
BOARD_ROOT_EXTRA_SYMLINKS := \
    /vendor/dsp:/dsp \
    /vendor/firmware_mnt:/firmware \
    /vendor/bt_firmware:/bt_firmware

# RenderScript
OVERRIDE_RS_DRIVER := libRSDriver_adreno.so

# RIL
ENABLE_VENDOR_RIL_SERVICE := true
TARGET_RIL_VARIANT := caf

# Security patch level
VENDOR_SECURITY_PATCH := 2019-07-10

# SELinux
include device/qcom/sepolicy/sepolicy.mk
BOARD_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# Timeservice
BOARD_USES_QC_TIME_SERVICES := true

# Treble
# BOARD_VNDK_VERSION := current
PRODUCT_FULL_TREBLE_OVERRIDE := true

# Verified Boot
BOARD_AVB_ENABLE := true
BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 2

# Wi-Fi
BOARD_HAS_QCOM_WLAN := true
BOARD_HAS_QCOM_WLAN_SDK := true
BOARD_WLAN_DEVICE := qcwcn
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_$(BOARD_WLAN_DEVICE)
QC_WIFI_HIDL_FEATURE_DUAL_AP := true
WIFI_DRIVER_FW_PATH_AP := "ap"
WIFI_DRIVER_FW_PATH_STA := "sta"
WIFI_DRIVER_FW_PATH_P2P := "p2p"
WIFI_HIDL_FEATURE_DUAL_INTERFACE := true
WPA_SUPPLICANT_VERSION := VER_0_8_X

# inherit from the proprietary version
-include vendor/smartisan/trident/BoardConfigVendor.mk
