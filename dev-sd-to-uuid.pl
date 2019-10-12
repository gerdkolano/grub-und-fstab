#!/usr/bin/perl
# /home/hanno/erprobe/grub-und-fstab/dev-sd-to-uuid.pl
# cpan install Switch.pm

use warnings;
use strict;

sub hersteller {
  my $arg = shift;
  my ($disk_by_id, $ZEILE);
  $disk_by_id = "ls -l /dev/disk/by-uuid";

  open $ZEILE, "$disk_by_id |" or die "Kann $disk_by_id nicht lesen.";

  my ($label, $uuid, $type, $device);

  while (<$ZEILE>) {
    # print;
    while(m#([^ ]*) -> ../../(sd..)$#g) {
      my $oem = $1;
      my $dev = $2;
      if ($arg =~ /$dev/) { # #/dev/sdd# =~ #sdd#
        return $oem;
      }
    }
  }
  return "nicht vorhanden";
}

#foreach my $dev ( qw/ "sda" "sdb" "sdc" "sdd" "sde" "sdf"/) {
foreach my $dev ( qw/ sda sdb sdc sdd sde sdf/) {
  foreach my $partno ( qw/ 1 2 3 4 5 6/) {
    printf "%s %s\n", "$dev$partno", hersteller( "$dev$partno");
  }
}

#ls -l /dev/disk/by-id/ata-* | perl -ne 'while(m#(/dev[^ ]*) -> ../../(sd.)$#g){if ($2 eq "sdd"){printf "%s %s\n", $1, $2}}'

