#!/usr/bin/perl

use warnings;
use strict;

sub blkid {
  my ($blkid, $BLK);
  $blkid = "blkid";
  
  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";
  
  my ($label, $uuid, $type);
    
  while (<$BLK>) {
    print;
    
    $label="";
    while(m#(UUID=)"([^"]*)#g) {
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
    #print "$uuid $label ext4 rw,nosuid,nodev,uhelper=devkit 1 2\n" if $type eq "ext4";
    #print "$uuid none   swap sw                             0 0\n" if $type eq "swap";
  }
}

sub grub_probe {
  my ($blkid, $BLK);
  $blkid = "grub-probe --target=fs_uuid /roota";

  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";

  my ($label, $uuid, $type);

  while (<$BLK>) {
    print;
  }
}

sub fstab {
  my ($blkid, $BLK);
  $blkid = "blkid";
  
  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";
  
  my ($label, $uuid, $type);
    
  while (<$BLK>) {
    #print;
    
    $label="";
    while(m#(UUID=)"([^"]*)#g) {
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

grub_probe();
#blkid();
# fstab();

# > /tmp/fstab

