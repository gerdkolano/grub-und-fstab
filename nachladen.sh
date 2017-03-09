#!/bin/sh

echo "Hannos Nachladen cp -auv /home/hanno/erprobe/grub-und-fstab/nachladen.sh /etc/grub.d/50-hanno-nachladen" >&2

for i in `ls /root?/boot/grub/grub.cfg | cut -f1-2 -d/` ; do
cat <<ENDE
menuentry "Nachladen der grub.cfg von $i=$(grub-probe --target=device $i)" {
        insmod ext2
        insmod part_gpt
        set root='$(grub-probe --target=compatibility_hint $i)'
        configfile  /boot/grub/grub.cfg
}
ENDE
done

exit 0

menuentry "Nachladen der grub.cfg von /dev/sdf1" {
        insmod ext2
        insmod part_gpt
        set root='(hd5,1)'
        configfile  /boot/grub/grub.cfg
}
#

/roota  hd3,gpt2 /dev/sdd2
/rootb  hd3,gpt3 /dev/sdd3
/roote  hd0,gpt2 /dev/sda2
/rootg  hd1,gpt1 /dev/sdb1
/rooto  hd2,gpt2 /dev/sdc2
/rootp  hd2,gpt3 /dev/sdc3

