#!/bin/bash

# Paths
KERNEL_DIR=$(pwd)
RESOURCE_DIR="${KERNEL_DIR}"
ANYKERNEL_DIR="$KERNEL_DIR/Blackthunder-AK2"
ANYKERNEL_BRANCH=pixi4_4
REPACK_DIR="$ANYKERNEL_DIR"
ZIMAGE_DIR="$KERNEL_DIR/arch/arm/boot"

# Resources
THREAD="-j4"
KERNEL="zImage-dtb"
DEFCONFIG="blackthunder_pixi4_4_8g1g_defconfig"
#TOOLCHAIN_PREFIX=arm-eabi
#TOOLCHAIN_DIR=${TOOLCHAIN_PREFIX}

KERNEL_NAME="BlackThunder"
VER="v1.0"
LOCALVERSION="-$( date +%Y%m%d )"
DEVICE="pixi4_4"
BASE_BT_VER="BT"
BT_VER="$BASE_BT_VER$VER-${DEVICE}${LOCALVERSION}-$( date +%H%M )"


# Vars
export ARCH=arm ARCH_MTK_PLATFORM=mt6580
export KBUILD_BUILD_USER=kirito9
export KBUILD_BUILD_HOST=aincrad

# Clean AnyKernel directory if it exists, clone it if not
if [[ -d ${ANYKERNEL_DIR} ]]; then
    cd ${ANYKERNEL_DIR}
    git checkout ${ANYKERNEL_BRANCH}
    git fetch origin
    git reset --hard origin/${ANYKERNEL_BRANCH}
    git clean -fdx > /dev/null 2>&1
    rm -rf ${KERNEL} > /dev/null 2>&1
else
	cd ${KERNEL_DIR}
    git clone https://github.com/kirito96/AnyKernel2 -b ${ANYKERNEL_BRANCH} Blackthunder-AK2
fi

export USE_CCACHE=1

rm -rf $REPACK_DIR/zImage-dtb
rm -rf $ZIMAGE_DIR/$KERNEL
make clean && make mrproper
make $DEFCONFIG
make $THREAD
cp -vr $ZIMAGE_DIR/$KERNEL $REPACK_DIR
cd $REPACK_DIR
rm -rf .git
zip -9 -r `echo $BT_VER`.zip .
mv  `echo $BT_VER`.zip $REPACK_DIR
cd $ANYKERNEL_DIR
curl --upload-file `echo $BT_VER`.zip https://transfer.sh/`echo $BT_VER`.zip 
cd $KERNEL_DIR
