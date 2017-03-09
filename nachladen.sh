#!/bin/sh

echo "Hannos Nachladen cp -auv /home/hanno/erprobe/grub-und-fstab/nachladen.sh /etc/grub.d/50-hanno-nachladen" >&2

for i in `ls /root?/boot/grub/grub.cfg | cut -f1-2 -d/` ; do
              device=$(grub-probe --target=device             $i);
  compatibility_hint=$(grub-probe --target=compatibility_hint $i);
             fs_uuid=$(grub-probe --target=fs_uuid            $i);
cat <<ENDE
menuentry "Nachladen der grub.cfg von $i=$device=$compatibility_hint=$fs_uuid" {
        insmod ext2
        insmod part_gpt
        configfile ($compatibility_hint)/boot/grub/grub.cfg
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

menuentry "Nachladen der grub.cfg von /rootg=/dev/sdb1=hd2,gpt1" {
        insmod ext2
        insmod part_gpt
        configfile (hd2,gpt1)/boot/grub/grub.cfg
}

ohne device.map
/roota  hd3,gpt2 /dev/sdd2
/rootb  hd3,gpt3 /dev/sdd3
/roote  hd0,gpt2 /dev/sda2
/rootg  hd1,gpt1 /dev/sdb1
/rooto  hd2,gpt2 /dev/sdc2
/rootp  hd2,gpt3 /dev/sdc3

mit device.map
-rw-r--r-- 1 root root 0 Feb 10 09:14 /roote/boot/grub/sda2_roote_f667
-rw-r--r-- 1 root root 0 Feb 10 09:14 /rootg/boot/grub/sdb1_rootg_43d6
-rw-r--r-- 1 root root 0 Feb 10 09:15 /rooto/boot/grub/sdc2_rooto_64ea
-rw-r--r-- 1 root root 0 Feb 10 09:15 /rootp/boot/grub/sdc3_rootp_7d9a
-rw-r--r-- 1 root root 0 Feb 10 09:16 /roota/boot/grub/sdd2_roota_db04
-rw-r--r-- 1 root root 0 Feb 10 09:16 /rootb/boot/grub/sdd3_rootb_8d5f

