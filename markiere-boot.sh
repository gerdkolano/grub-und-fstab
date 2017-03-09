#!/bin/sh

lsblk --list --output MOUNTPOINT,NAME,LABEL,UUID \
  | perl -ne 'while(m#(/r[^ ]*)\W*([^ ]*)\W*([^ ]*)\W*(....)([^ ]*)\W.*#g){$k="touch $1/boot/grub/$2_$3_$4";print "$k\n";system "$k"}'

# exit 0

lsblk --list --output name,MOUNTPOINT,NAME,LABEL,UUID,MODEL,SERIAL

# exit 0
 lsblk --list --output MOUNTPOINT,NAME,LABEL,UUID \
  | perl -ne 'while(m#(/r[^ ]*)\W*([^ ]*)\W*([^ ]*)\W*(....)([^ ]*)\W.*#g){system "ls -lt $1/boot/grub/$2_$3_$4\n"}'

