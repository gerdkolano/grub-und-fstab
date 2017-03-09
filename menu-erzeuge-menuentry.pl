#!/usr/bin/perl

use warnings;
use strict;

my ($blkid, $BLK);
$blkid = "blkid";

open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";

my ($label, $uuid, $type);
  
while (<$BLK>) {
  #print;
  
  $label="";
  while(m#(UUID=)"([^"]*)#g) {
    $uuid="$1$2";
  }
  while(m#(LABEL=)"([^"]*)#g) {
    $label="$2";
  }
  while(m#(TYPE=)"([^"]*)#g) {
    $type="$2";
  }
  $label=($label eq ""?"      ":"/$label");
  print "$uuid $label ext4 rw,nosuid,nodev,uhelper=devkit 1 2\n" if $type eq "ext4";
  print "$uuid none   swap sw                             0 0\n" if $type eq "swap";
}

exit 0 

# > /tmp/fstab

#!/bin/bash

# for n in /root?/boot ; do echo "################ $n"; ls $n/vmlinuz* | tail -1; ls $n/init* | tail -1;done

# menuentry "0793 /dev/sdc1 /roote hd2,gpt1 3.13.0-79" {
#     recordfail
#     load_video
#     gfxmode $linux_gfx_mode
#     insmod gzio
#     insmod ext2
#     insmod ext2
#     insmod part_gpt
#     set root='(hd2,gpt1)'
#     search --no-floppy --fs-uuid --set=root         07936a3d-dfde-4b96-8ee6-c844e869c56f
#     linux /boot/vmlinuz-3.13.0-79-generic root=UUID=07936a3d-dfde-4b96-8ee6-c844e869c56f ro noquiet nosplash
# initrd /boot/initrd.img-3.13.0-79-generic
# }


