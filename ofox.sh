#!/bin/bash
TARGET_DEVICE=RMX1851
# configure some default settings for the build
Default_Settings() {
	export ALLOW_MISSING_DEPENDENCIES=true
	export TARGET_ARCH="arm64"
	export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER="1"
	export LC_ALL="C"
	export USE_CCACHE="1"
	export FOX_REPLACE_BUSYBOX_PS="1"
	export FOX_USE_BASH_SHELL="1"
	export FOX_USE_NANO_EDITOR="1"
    	export OF_NO_TREBLE_COMPATIBILITY_CHECK="1"
#       export FOX_USE_LZMA_COMPRESSION="1"
    	export FOX_DELETE_AROMAFM="1"
    	export OF_DISABLE_MIUI_SPECIFIC_FEATURES="1"
	export OF_MAINTAINER="AJITH"
	export FOX_BUILD_FULL_KERNEL_SOURCES="1"
	export OF_FLASHLIGHT_ENABLE="1"
	export OF_SCREEN_H="2340"
	export OF_STATUS_INDENT_LEFT="48"
	export OF_STATUS_INDENT_RIGHT="48"
	export OF_SUPPORT_OZIP_DECRYPTION="1"
	export BUILD_TYPE="Stable"
        export OF_USE_NEW_MAGISKBOOT="1"
        export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES="1"
	export FOX_ADVANCED_STOCK_REPLACE="1"

	# lzma
  	[ "$FOX_USE_LZMA_COMPRESSION" = "1" ] && export LZMA_RAMDISK_TARGETS="recovery"
}

# build the project
do_build() {
  Default_Settings

  # use ccache ??
  [ "$USE_CCACHE" = "1" ] && ccache -M 20G

  # compile it
  . build/envsetup.sh

  lunch omni_"$TARGET_DEVICE"-eng

  mka recoveryimage -j$(nproc --all) && cd device/realme/RMX1851
}

# --- main --- #
cd .. && cd .. && cd .. && do_build
#
