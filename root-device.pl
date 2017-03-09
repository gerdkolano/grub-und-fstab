#!/usr/bin/perl
use warnings; use strict;

sub root_device {
  my $dev;
  open EIN, "df --output=source / |";
  while(<EIN>) {
    chop;$dev = $_  if /\//;
  }
  close EIN;
  # print "dev = $dev\n";
  
  my $mountpoint;
  open EIN, "mount -l |";
  while(<EIN>) {
    chop;
    if (index ($_, $dev) >-1) {
      s/([^\s]+\s+[^\s]+\s+[^\s]+).*/$1/; $mountpoint = $_ ;
    }
  }
  close EIN;
  return "$mountpoint";
}

printf "%s", root_device();

# /dev/sdc2 on / type ext4 (rw,errors=remount-ro) [rooto]
# /dev/sdc2 on /rooto type ext4 (rw,nosuid,nodev,uhelper=devkit) [rooto]
#
# mount -l | grep `df --output=source / | grep dev`  | perl -ne 's/([^\s]+\s+[^\s]+\s+[^\s]+).*/$1/; print if $.==2' 
