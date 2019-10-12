#!/bin/sh

echo "Hannos Nachladen cp -auv /home/hanno/erprobe/grub-und-fstab/nachladen.sh /etc/grub.d/51-hanno-nachladen" >&2

for i in hd0 hd1 hd2 hd3 hd4 hd5 ; do
for j in gpt1 gpt2 gpt3 ; do
hd_gpt=$i,$j
cat <<ENDE
menuentry "$hd_gpt Nachladen der grub.cfg" {
        insmod ext2
        insmod part_gpt
        configfile ($hd_gpt)/boot/grub/grub.cfg
}
ENDE
done
done

exit 0

menuentry "Nachladen der grub.cfg von /dev/sdf1" {
        insmod ext2
        insmod part_gpt
        set root='(hd5,1)'
        configfile  /boot/grub/grub.cfg
}
#

