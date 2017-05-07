# AnyKernel2 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
properties() {
kernel.string=BlackThunder by kirito9
do.devicecheck=0
do.modules=0
do.cleanup=1
do.cleanuponabort=0
device.name1=Pixi4-4
device.name2=4034D
device.name3=
device.name4=
device.name5=
} # end properties

# shell variables
block=/dev/block/platform/mtk-msdc.0/11120000.msdc0/by-name/boot;
is_slot_device=0;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. /tmp/anykernel/tools/ak2-core.sh;


## AnyKernel permissions
# set permissions for included ramdisk files
chmod -R 755 $ramdisk

## AnyKernel install
dump_boot;

# begin ramdisk changes

# end ramdisk changes

write_boot;

## end install

