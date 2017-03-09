#!/usr/bin/perl

use warnings;
use strict;

sub fstabi_obsolet {
  my ($blkid, $BLK);
  $blkid = "blkid";
  
  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";
  
  my ($label, $uuid, $type);
    
  while (<$BLK>) {
    #print;
    
    $label="";
    while(m# (UUID=)"([^"]*)#g) {
      $uuid="$1$2";
    }
    while(m#(LABEL=)"([^"]*)#g) {
      $label="$2";
    }
    while(m#(TYPE=)"([^"]*)#g) {
      $type="$2";
    }
    $label = ($label eq "" 
      ? "      " 
      : "/$label"
    );
    print "$uuid $label ext4 rw,nosuid,nodev,uhelper=devkit 1 2\n" if $type eq "ext4";
    print "$uuid none   swap sw                             0 0\n" if $type eq "swap";
  }
}

sub fstab {
  my ($blkid, $BLK);
  $blkid = "blkid";

  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";

  my ($label, $uuid, $type, $device);

  while (<$BLK>) {
    #print;

    $label="";
    while(m#(^/dev/[^:]*)#g) {
      $device="$1";
    }
    while(m# (UUID=)"([^"]*)#g) {
      $uuid="$1$2";
    }
    while(m#(LABEL=)"([^"]*)#g) {
      $label="$2";
    }
    while(m#(TYPE=)"([^"]*)#g) {
      $type="$2";
    }
    $label=($label eq "" ? "/" . substr( $uuid, 5, 4) . " " : "/$label");
    print "$uuid $label ext4 rw,nosuid,nodev,uhelper=devkit 1 2 # $device\n" if $type eq "ext4";
    print "$uuid none   swap sw                             0 0 # $device\n" if $type eq "swap";
  }
}

fstab();

# > /tmp/fstab

