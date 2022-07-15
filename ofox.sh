#!/bin/bash
#
#	This file is part of the OrangeFox Recovery Project
# 	Copyright (C) 2021 The OrangeFox Recovery Project
#
#	OrangeFox is free software: you can redistribute it and/or modify
#	it under the terms of the GNU General Public License as published by
#	the Free Software Foundation, either version 3 of the License, or
#	any later version.
#
#	OrangeFox is distributed in the hope that it will be useful,
#	but WITHOUT ANY WARRANTY; without even the implied warranty of
#	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#	GNU General Public License for more details.
#
# 	This software is released under GPL version 3 or any later version.
#	See <http://www.gnu.org/licenses/>.
#
# 	Please maintain this if you use this script or any part of it
#
FDEVICE="RMX1851"

fox_get_target_device() {
local chkdev=$(echo "$BASH_SOURCE" | grep -w $FDEVICE)
    if [ -n "$chkdev" ]; then
        FOX_BUILD_DEVICE="$FDEVICE"
    else
        chkdev=$(set | grep BASH_ARGV | grep -w $FDEVICE)
        [ -n "$chkdev" ] && FOX_BUILD_DEVICE="$FDEVICE"
    fi
}

if [ -z "$1" -a -z "$FOX_BUILD_DEVICE" ]; then
    fox_get_target_device
fi

if [ "$1" = "$FDEVICE" -o "$FOX_BUILD_DEVICE" = "$FDEVICE" ]; then
    export OF_MAINTAINER="kanged99"
    export FOX_VERSION="R11.1_4"
    export FOX_BUILD_TYPE="Stable"
    export TARGET_ARCH=arm64
    export OF_USE_MAGISKBOOT=1
    export OF_USE_MAGISKBOOT_FOR_ALL_PATCHES=1
    export OF_DONT_PATCH_ENCRYPTED_DEVICE=1
    export OF_NO_RELOAD_AFTER_DECRYPTION=1
    export FOX_DISABLE_APP_MANAGER=1
    export OF_STATUS_INDENT_LEFT=48
    export OF_STATUS_INDENT_RIGHT=48
    export OF_HIDE_NOTCH=1
    export OF_ALLOW_DISABLE_NAVBAR=0
    export OF_CHECK_OVERWRITE_ATTEMPTS=1
    export OF_RUN_POST_FORMAT_PROCESS=1
    export FOX_ADVANCED_SECURITY=1
    export OF_NO_SAMSUNG_SPECIAL=1
    export OF_USE_TWRP_SAR_DETECT=1
    export FOX_DELETE_AROMAFM=1
    export FOX_USE_TWRP_RECOVERY_IMAGE_BUILDER=1
    export OF_NO_TREBLE_COMPATIBILITY_CHECK=1
    export OF_SKIP_ORANGEFOX_PROCESS=1
    export OF_SUPPORT_OZIP_DECRYPTION=1
    export OF_QUICK_BACKUP_LIST="/boot;/dtbo;"
    export FOX_USE_SPECIFIC_MAGISK_ZIP="/home/hyper/ahmed/fox_12.1/device/realme/RMX1851/Magisk-v25.1.zip"
    export OF_DONT_PATCH_ON_FRESH_INSTALLATION=1
    export OF_TWRP_COMPATIBILITY_MODE=1
    export FOX_REPLACE_BUSYBOX_PS=1
    export FOX_REPLACE_TOOLBOX_GETPROP=1
    export FOX_USE_NANO_EDITOR=1
    export FOX_USE_BASH_SHELL=1
    export FOX_ASH_IS_BASH=1
    export FOX_USE_TAR_BINARY=1
    export FOX_USE_XZ_UTILS=1
    export FOX_USE_SED_BINARY=1
    export FOX_USE_LZMA_COMPRESSION=1
    export OF_ENABLE_LPTOOLS=1
    export OF_KEEP_DM_VERITY_FORCED_ENCRYPTION=1
    export OF_SKIP_DECRYPTED_ADOPTED_STORAGE=1
    # lzma
    [ "$FOX_USE_LZMA_COMPRESSION" = "1" ] && export LZMA_RAMDISK_TARGETS="recovery"
	
    # Let's see which are our build vars
    if [ -n "$FOX_BUILD_LOG_FILE" -a -f "$FOX_BUILD_LOG_FILE" ]; then
        export | grep "FOX" >> $FOX_BUILD_LOG_FILE
        export | grep "OF_" >> $FOX_BUILD_LOG_FILE
        export | grep "TARGET_" >> $FOX_BUILD_LOG_FILE
        export | grep "TW_" >> $FOX_BUILD_LOG_FILE
    fi
fi

# build the project
do_build() {

  # use ccache ??
  [ "$USE_CCACHE" = "1" ] && ccache -M 20G

  # compile it
  cd ~/ahmed/fox_12.1/
  export ALLOW_MISSING_DEPENDENCIES=true
  . build/envsetup.sh

  lunch twrp_"$FOX_BUILD_DEVICE"-eng

  time mka recoveryimage && cd device/realme/RMX1851
}

# --- main --- #
cd .. && cd .. && cd .. && do_build

# --- upload --- #
zipfile=$(find /home/hyper/ahmed/fox_12.1/out/target/product/RMX1851/ -iname OrangeFox-*.zip -printf "%f\n")
scp /home/hyper/ahmed/fox_12.1/out/target/product/RMX1851/$zipfile hyper@hyper.remainsilent.net:/var/www/html/builds/roms/RMX1851
echo " file uploaded successfully . please download at http://hyper.remainsilent.net/builds/roms/RMX1851/$zipfile "
