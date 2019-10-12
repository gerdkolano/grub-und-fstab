#!/bin/sh

chmod -v a-x /etc/grub.d/15-*
mv -v /tmp/15-hanno-* /etc/grub.d
echo Vorschlag purge
dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' # | xargs sudo apt-get -y purge
echo Ende Vorschlag purge
ls -l --time-style='+%Y-%m-%d-%H-%M-%S' /boot/grub/grub.cfg | perl -ne 'while(m#([^ ]*) /boot/grub/grub.cfg#g){system "cp -auv /boot/grub/grub.cfg /boot/grub/$1-grub.cfg\n"}'
update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg


