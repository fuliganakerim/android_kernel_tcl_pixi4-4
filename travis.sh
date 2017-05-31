#!/bin/bash

export USE_CCACHE=1
export ARCH=arm ARCH_MTK_PLATFORM=mt6580
make clean 
make pixi4_4_8g1g_defconfig
make -j4
