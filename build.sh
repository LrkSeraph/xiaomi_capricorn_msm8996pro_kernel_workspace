#!/usr/bin/env bash
TOOLCHAINS=$(realpath $(dirname $(readlink $0))/toolchain)
export PATH="$TOOLCHAINS/aarch64-linux-android-4.9/bin:$PATH"
export PATH="$TOOLCHAINS/binutils-2.28-aarch64-linux-android/bin:$PATH"
export INSTALL_MOD_PATH="$(realpath $(dirname $0)/../sysroot)"
export INSTALL_MOD_STRIP=1
KDIR=$(readlink -f $(dirname $0))
RESOURCE=$(readlink -f $(realpath $(dirname $0)/../mkbootimg_resource))
OUT=$(readlink -f $KDIR/out)
# build boot.img and vendor_boot.img
if [[ "$1" == "bootimg" ]]; then
	python3 $TOOLCHAINS/mkbootimg/mkbootimg.py \
		--header_version 0 \
		--kernel $OUT/arch/arm64/boot/Image.gz-dtb \
		--ramdisk $RESOURCE/ramdisk \
		--pagesize 0x00001000 \
		--base 0x00000000 \
		--kernel_offset 0x80008000 \
		--ramdisk_offset 0x81000000 \
		--second_offset 0x80f00000 \
		--tags_offset 0x80000100 \
		--board '' \
		--cmdline 'console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 androidboot.hardware=qcom user_debug=31 msm_rtb.filter=0x237 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 cma=32M@0-0xffffffff buildvariant=user mitigations=off' \
		-o $OUT/boot.img
		exit
fi
if [[ "$1" == "flash" ]]; then
	fastboot flash boot $OUT/boot.img
	fastboot reboot
	exit
fi
make \
O=out \
INSTALL_MOD_PATH=sysroot \
ARCH=arm64 \
SUBARCH=ARM64 \
CLANG_TRIPLE=aarch64-linux-gnu- \
CROSS_COMPILE=aarch64-linux-android- \
CROSS_COMPILE_ARM32=arm-linux-androideabi- \
CONFIG_DEBUG_SECTION_MISMATCH=y \
"$@"
