#!/bin/bash

# Get kernel configuration
if [ -f kernel.conf ]
  then
    source "kernel.conf"
  else
	echo "Kernel configuration file (kernel.conf) does not exist!"
	exit -1
fi

export USE_CCACHE=1
export ARCH=arm ARCH_MTK_PLATFORM=mt6580
#make clean 
make pixi4_4_8g1g_defconfig
