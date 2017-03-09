#!/usr/bin/perl

use warnings;
use strict;

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
    $label=($label eq ""?"      ":"/$label");
    print "$uuid $label ext4 rw,nosuid,nodev,uhelper=devkit 1 2\n" if $type eq "ext4";
    print "$uuid none   swap sw                             0 0\n" if $type eq "swap";
  }
}

sub vmlinuz {
  my ($directory, $DIR);
  $directory = shift;
  # printf "%s\n", $directory;
  # system "ls " . sprintf( "/%s/boot/\n", $file);
  my (@liste_vmlinuz, @liste_initrd);
  opendir ($DIR, $directory) or return; #  or die "$directory " . $!;
  while (my $file = readdir($DIR)) {
    # printf "%s/%s\n", $directory, $file;
    push @liste_vmlinuz, sprintf( "%s/%s", $directory, $file) if ($file =~ m/^vmlinuz/);
    push @liste_initrd , sprintf( "%s/%s", $directory, $file) if ($file =~ m/^initrd/ );
  }
  @liste_vmlinuz = sort {$b cmp $a} @liste_vmlinuz; # reverse {$a cmp $b{ # numerically {$a <=> $b{
  printf "%s\n", $liste_vmlinuz[0];
  @liste_initrd = sort {$b cmp $a} @liste_initrd; # reverse {$a cmp $b{ # numerically {$a <=> $b{
  printf "%s\n", $liste_initrd[0];
#  foreach my $elem (@liste_initrd) {
#    printf "%s\n", $elem;
#  }
}

sub menu {
  my ($directory, $DIR);
  $directory = '/';
  # printf "%s\n", $directory;
  opendir ($DIR, $directory) or die $!;
  while (my $file = readdir($DIR)) {
    next if ($file =~ m/^\./  or ! ($file =~ m/^root./) );
    my $zu_suchen = sprintf "/%s/boot", $file;
    # printf "%s\n", $file;
    vmlinuz( $zu_suchen);
  }
}

# fstab();
menu();

exit 0 

# > /tmp/fstab

#!/bin/bash

# for n in /root?/boot ; do echo "################ $n"; ls $n/vmlinuz* | tail -1; ls $n/init* | tail -1;done

# menuentry "0793 /dev/sdc1 /roote hd2,gpt1 3.13.0-79" {
#     recordfail
#     load_video
#     gfxmode $linux_gfx_mode
#     insmod gzio
#     insmod ext2
#     insmod ext2
#     insmod part_gpt
#     set root='(hd2,gpt1)'
#     search --no-floppy --fs-uuid --set=root         07936a3d-dfde-4b96-8ee6-c844e869c56f
#     linux /boot/vmlinuz-3.13.0-79-generic root=UUID=07936a3d-dfde-4b96-8ee6-c844e869c56f ro noquiet nosplash
# initrd /boot/initrd.img-3.13.0-79-generic
# }


