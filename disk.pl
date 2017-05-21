#!/usr/bin/perl
use strict;
use warnings;

# LANG=en_US:en lshw -class disk | /home/hanno/erprobe/grub-und-fstab/disk.pl
# cat /proc/scsi/scsi
# cat /proc/scsi/sg/device_hdr 
# cat /proc/scsi/sg/devices
# ls -l /dev/disk/by-id/ 
# zoe  grub.cfg von rooto /dev/sdb2 ST10000VN0004-1Z ZA206713 parallel scsi0 laut /proc/scsi/scsi
# fadi grub.cfg von roota /dev/sde1 ST4000DM000-1F21 Z300JZRR          scsi0 laut /proc/scsi/scsi
# TODO /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl
my $EIN;
open $EIN, "LANG=en_US:en lshw -class disk | ";
print "logical name \t product \t\t vendor \tversion\tserial \t\tsize\n";
local $/ = undef; 
while(<$EIN>) {
while(m!
        product.      ([^\n]*)\n[ ]*  
     (?:vendor.       ([^\n]*)\n[ ]*)*
     (?:physical.id.  ([^\n]*)\n[ ]*)*
     (?:bus.info.     ([^\n]*)\n[ ]*)*
     (?:logical.name:.([^\n]*)\n[ ]*)*
     (?:version:.     ([^\n]*)\n[ ]*)*
     (?:serial:.      ([^\n]*)\n[ ]*)*
     (?:size:.        ([^\n]*)\n[ ]*)*
       !gsx) {
  # print "1+$1+ 2+$2+ 3+$3+ 4+$4+ 5+$5+ 6+$6+ ";
  # print "7+$7+ 8+$8+" if defined $7;
    my $vendor = " unbekannt"; $vendor = $2 if defined $2;
    print "$5\t$1\t$vendor\t$6";
    print "\t$7\t$8" if defined $7;
    print "\n";
  }
}
close $EIN;
