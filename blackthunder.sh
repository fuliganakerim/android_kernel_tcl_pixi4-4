#!/bin/bash
#Original script by hellsgod and modified with function from MSF Jarvis

# Bash colors
green='\033[01;32m'
red='\033[01;31m'
cyan='\033[01;36m'
blue='\033[01;34m'
blink_red='\033[05;31m'
restore='\033[0m'

clear

# Resources
THREAD="-j4"
KERNEL="zImage-dtb"
DEFCONFIG="pixi4_4_8g1g_defconfig"

# BlackThunder Kernel Details
KERNEL_NAME="BlackThunder"
VER="v1.2"
BASE_BT_VER="BT"
BT_VER="$BASE_BT_VER$VER-$( TZ=MST date +%Y%m%d )"

# Vars
export ARCH=arm
export KBUILD_BUILD_USER=kirito9
export KBUILD_BUILD_HOST=teampanther
export CROSS_COMPILE=~/android/toolchain/arm-eabi-4.8/bin/arm-eabi-

# Paths
KERNEL_DIR=`pwd`
RESOURCE_DIR="/home/kirito9/android/kernel/4034"
ANYKERNEL_DIR="$RESOURCE_DIR/BT-pixi4_4-AnyKernel2"
REPACK_DIR="$ANYKERNEL_DIR"
ZIP_MOVE="$RESOURCE_DIR/BT-releases/pixi4_4/"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm/boot"

# Functions
function clean_all {
		rm -rf $REPACK_DIR/zImage-dtb
		rm -rf $ZIMAGE_DIR/$KERNEL
		make clean && make mrproper
}

function make_kernel {
		make $DEFCONFIG
		make $THREAD
		cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR
		mv $REPACK_DIR/$KERNEL $REPACK_DIR/zImage
}

function make_zip {
		cd $REPACK_DIR
		zip -9 -r `echo $BT_VER`.zip .
		mv  `echo $BT_VER`.zip $ZIP_MOVE
		cd $KERNEL_DIR
}

function push_and_flash {
  adb push "$ZIP_MOVE"/${BT_VER}.zip /sdcard/
  adb shell twrp install "/sdcard/${BT_VER}.zip"
}

DATE_START=$(date +"%s")

echo -e "${green}"
echo "BlackThunder Kernel Creation Script:"
echo

echo "---------------"
echo "Kernel Version:"
echo "---------------"

echo -e "${red}"; echo -e "${blink_red}"; echo "$BT_VER"; echo -e "${restore}";

echo -e "${green}"
echo "-----------------"
echo "Making BlackThunder Kernel:"
echo "-----------------"
echo -e "${restore}"

while read -p "Please choose your option: [1]Clean-build // [2]Dirty-build // [3]Clean source // [4]Make flashable zip // [5]Flash to device // [6]Abort " cchoice
do
case "$cchoice" in
	1 )
		echo -e "${green}"
		echo
		echo "[..........Cleaning up..........]"
		echo
		echo -e "${restore}"
		clean_all
		echo -e "${green}"
		echo
		echo "[....Building `echo $BT_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		if [ -f $ZIMAGE_DIR/$KERNEL ];
		then
			make_zip
		else
			echo -e "${red}"
			echo
			echo "Kernel build failed, check your logs!"
			echo
			echo -e "${restore}"
		fi
		echo
		echo
		echo -e "${restore}"
		break
		;;
	2 )
		echo -e "${green}"
		echo
		echo "[....Building `echo $BT_VER`....]"
		echo
		echo -e "${restore}"
		make_kernel
		if [ -f $ZIMAGE_DIR/$KERNEL ];
		then
			make_zip
		else
			echo -e "${red}"
			echo
			echo "Kernel build failed, check your logs!"
			echo
			echo -e "${restore}"
		fi
		echo		
		echo
		echo -e "${restore}"
		break
		;;
	3 )
		echo -e "${green}"
		echo
		echo "[..........Cleaning up..........]"
		echo
		echo -e "${restore}"
		clean_all
		echo -e "${green}"
		echo
		echo -e "${restore}"		
		break
		;;
	4 )
		echo -e "${green}"
		echo
		echo "[....Make `echo $BT_VER`.zip....]"
		echo
		echo -e "${restore}"
		make_zip
		echo -e "${green}"
		echo
		echo "[.....Moving `echo $BT_VER`.....]"
		echo
		echo -e "${restore}"
		break
		;;
	5 )
		echo -e "${green}"
		echo
		echo "[....Pushing and Flashing `echo $BT_VER`.zip....]"
		echo
		echo -e "${restore}"
		push_and_flash
		echo -e "${green}"
		echo
		echo "[.....Pushing and Flashing `echo $BT_VER`.....]"
		echo
		echo -e "${restore}"
		break
		;;		
	6 )
		break
		;;
	* )
		echo -e "${red}"
		echo
		echo "Invalid try again!"
		echo
		echo -e "${restore}"
		;;
esac
done


if [ -f $ZIMAGE_DIR/$KERNEL ];
then
	echo -e "${green}"
	echo "-------------------"
	echo "Build Completed in:"
	echo "-------------------"
	echo -e "${restore}"
fi


DATE_END=$(date +"%s")
DIFF=$(($DATE_END - $DATE_START))
echo "Time: $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
echo
