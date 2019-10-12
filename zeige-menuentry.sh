#!/bin/sh

ls /dev/disk/by-label/ | while read i ; do f=/$i/boot/grub/grub.cfg; test -e $f && grep -Eom1 "menuentry '[^']*'" /$f; done
echo
                                           f=/boot/grub/grub.cfg;    test -e $f && grep -Eom1 "menuentry '[^']*'" /$f      
