#!/usr/bin/perl
use warnings;
use strict;

open my $LSBLK, "/bin/lsblk --list --output MOUNTPOINT,NAME,LABEL,UUID |";
while (<$LSBLK>) {
  # print;
  while(m#(/r[^ ]*)\W*([^ ]*)\W*([^ ]*)\W*(....)([^ ]*)\W.*#g) {
    my $k="touch $1/boot/grub/$2_$3_$4";
    open my $GRUBDEV, "/usr/sbin/grub-probe -t compatibility_hint -d /dev/$2 |";
    my $dev="";
    while (my $erg=<$GRUBDEV>) {
      $dev.=$erg;
    }
    close $GRUBDEV;
    $k .= "_$dev";
    print "$k";
    system "$k"
  }
}
close $LSBLK;

