#!/bin/sh

echo "Hannos iso" >&2

cat <<ENDE
menuentry "Ubuntu 16.04.2 ISO" {
        insmod ext2
        insmod part_gpt
        set isofile="/rooto/boot/ubuntu-16.04.2-desktop-amd64.iso"
        loopback loop (hd2,gpt2)$isofile
        linux (loop)/casper/vmlinuz.efi boot=casper iso-scan/filename=$isofile noprompt noeject
        initrd (loop)/casper/initrd.lz
}
ENDE

exit 0
