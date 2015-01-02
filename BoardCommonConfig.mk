COMMON_FOLDER := device/lge/u2-common
WITH_DEXPREOPT := true

PRODUCT_VENDOR_KERNEL_HEADERS := $(COMMON_FOLDER)/kernel-headers
TARGET_SPECIFIC_HEADER_PATH := $(COMMON_FOLDER)/include

# inherit from the proprietary version
-include vendor/lge/u2-common/BoardConfigVendor.mk

TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := omap4
TARGET_BOARD_OMAP_CPU := 4430
TARGET_CPU_ABI := armeabi-v7a
TARGET_CPU_ABI2 := armeabi
TARGET_BOOTLOADER_BOARD_NAME := u2
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := cortex-a9
TARGET_ARCH := arm
TARGET_ARCH_VARIANT := armv7-a-neon
TARGET_ARCH_VARIANT_CPU := $(TARGET_CPU_VARIANT)
TARGET_ARCH_VARIANT_FPU := neon
ARCH_ARM_HAVE_TLS_REGISTER := true
NEEDS_ARM_ERRATA_754319_754320 := true
BOARD_GLOBAL_CFLAGS += -DNEEDS_ARM_ERRATA_754319_754320

# Kernel
BOARD_KERNEL_CMDLINE := androidboot.selinux=permissive selinux=0
BOARD_KERNEL_BASE := 0x80000000
BOARD_KERNEL_PAGESIZE := 2048
TARGET_KERNEL_CONFIG := cyanogenmod_p760_defconfig
TARGET_KERNEL_SOURCE := kernel/lge/omap4-common
# TARGET_PREBUILT_KERNEL := $(DEVICE_FOLDER)/kernel

# Recovery
BOARD_HAS_NO_SELECT_BUTTON := true
TARGET_RECOVERY_FSTAB = device/lge/u2-common/fstab.u2
RECOVERY_FSTAB_VERSION = 2
BOARD_UMS_LUNFILE := "/sys/devices/virtual/android_usb/android0/f_mass_storage/lun/file"
TARGET_OTA_ASSERT_DEVICE := p760,p765,p768,p769,u2

# libwvm needs this, among other things
COMMON_GLOBAL_CFLAGS += -DNEEDS_VECTORIMPL_SYMBOLS

# EGL
# BOARD_EGL_CFG := device/lge/u2-common/egl.cfg
TARGET_RUNNING_WITHOUT_SYNC_FRAMEWORK := true
TARGET_HAS_WAITFORVSYNC := true
# Force the screenshot path to CPU consumer
COMMON_GLOBAL_CFLAGS += -DFORCE_SCREENSHOT_CPU_PATH
USE_OPENGL_RENDERER := true
BOARD_USE_TI_DUCATI_H264_PROFILE := true
TARGET_NEEDS_BIONIC_MD5 := true
TARGET_ENABLE_NON_PIE_SUPPORT := true
MALLOC_IMPL := dlmalloc

# Wifi related defines
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_HOSTAPD_DRIVER := NL80211
BOARD_HOSTAPD_PRIVATE_LIB := lib_driver_cmd_bcmdhd
BOARD_WLAN_DEVICE := bcmdhd
WIFI_DRIVER_FW_PATH_PARAM := "/sys/module/bcmdhd/parameters/firmware_path"
WIFI_DRIVER_FW_PATH_STA := "/vendor/firmware/fw_bcmdhd.bin"
WIFI_DRIVER_FW_PATH_AP := "/vendor/firmware/fw_bcmdhd_apsta.bin"
BOARD_WLAN_DEVICE_REV := bcm4330_b1
WIFI_BAND := 802_11_ABGN

# Bluetooth
BOARD_HAVE_BLUETOOTH := true
BOARD_HAVE_BLUETOOTH_BCM := true
BOARD_BLUEDROID_VENDOR_CONF := device/lge/u2-common/configs/vnd_u2.txt

# Setup custom omap4xxx defines
BOARD_USE_CUSTOM_LIBION := true
BOARD_HAL_STATIC_LIBRARIES := libhealthd.u2

# OMX
HARDWARE_OMX := true
OMAP_ENHANCEMENT := true
BOARD_USE_TI_ENHANCED_DOMX := true
ifdef OMAP_ENHANCEMENT
COMMON_GLOBAL_CFLAGS += -DOMAP_ENHANCEMENT -DTARGET_OMAP4 -DFORCE_SCREENSHOT_CPU_PATH
endif

# Makefile variable and C/C++ macro to recognise DOMX version
ifdef BOARD_USE_TI_ENHANCED_DOMX
    BOARD_USE_TI_DUCATI_H264_PROFILE := true
    TI_CUSTOM_DOMX_PATH := $(COMMON_FOLDER)/domx
    BOARD_USE_TI_CUSTOM_DOMX := true
    DOMX_PATH := $(COMMON_FOLDER)/domx
    TARGET_SPECIFIC_HEADER_PATH += $(COMMON_FOLDER)/domx/omx_core/inc
    ENHANCED_DOMX := true
else
    DOMX_PATH := hardware/ti/omap4xxx/domx
endif

TARGET_TI_HWC_HDMI_DISABLED := true

# HWComposer
BOARD_USE_SYSFS_VSYNC_NOTIFICATION := true

# FS
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 1033686220
BOARD_USERDATAIMAGE_PARTITION_SIZE := 2469606195
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_HAS_NO_MISC_PARTITION := true

BOARD_HAS_VIBRATOR_IMPLEMENTATION := ../../device/lge/u2-common/vibrator.c

# Camera
USE_CAMERA_STUB := false
COMMON_GLOBAL_CFLAGS += -DQCOM_LEGACY_UIDS

# External SGX Module
SGX_MODULES:
	make clean -C $(COMMON_FOLDER)/sgx-module/eurasiacon/build/linux2/omap4430_android
	cp $(TARGET_KERNEL_SOURCE)/drivers/video/omap2/omapfb/omapfb.h $(KERNEL_OUT)/drivers/video/omap2/omapfb/omapfb.h
	make -j8 -C $(COMMON_FOLDER)/sgx-module/eurasiacon/build/linux2/omap4430_android ARCH=arm KERNEL_CROSS_COMPILE=arm-eabi- CROSS_COMPILE=arm-eabi- KERNELDIR=$(KERNEL_OUT) TARGET_PRODUCT="blaze_tablet" BUILD=release TARGET_SGX=540 PLATFORM_VERSION=4.0
	mv $(KERNEL_OUT)/../../target/kbuild/pvrsrvkm_sgx540_120.ko $(KERNEL_MODULES_OUT)
	$(ARM_EABI_TOOLCHAIN)/arm-eabi-strip --strip-unneeded $(KERNEL_MODULES_OUT)/pvrsrvkm_sgx540_120.ko

TARGET_KERNEL_MODULES += SGX_MODULES

## Radio fixes
BOARD_RIL_CLASS := ../../../device/lge/u2-common/ril/

# Charger
BOARD_CHARGER_ENABLE_SUSPEND := true

TARGET_PROVIDES_TI_FM_SERVICE := true

# SELinux

BOARD_SEPOLICY_DIRS += \
    device/lge/u2-common/selinux

BOARD_SEPOLICY_UNION += \
	file_contexts \
        fRom.te \
        init.te \
        mediaserver.te \
        pvrsrvinit.te \
        rild.te \
	bluetooth.te \
	sdcardd.te \
	servicemanager.te \
	system_server.te \
	zygote.te \
	device.te \
        domain.te

FORCE_PERMISSIVE_TO_UNCONFINED:=false

# CMHW
BOARD_HARDWARE_CLASS := device/lge/u2-common/cmhw/
