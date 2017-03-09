#!/usr/bin/perl
# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl  > /tmp/08-hanno-fadi
# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl  > /tmp/07-hanno-zoe
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

sub grub_probe {
  my $target = shift;
  my $rootv = shift;
  my ($blkid, $BLK);
  $blkid = "grub-probe --target=$target $rootv";

  open $BLK, "$blkid |" or die "Kann $blkid nicht lesen.";

  my ($label, $uuid, $type);

  while (<$BLK>) {
    chomp;
    return $_;
  }
}

sub menuentry {
  my $uuid     = shift;
  my $set_root = shift;
  my $device   = shift;
  my $rootv    = shift;
  my $vmlinuz  = shift;
  my $initrd   = shift;

  my ($short_uuid) = $uuid =~ /(^....)/;
  my ($short_kernel) = $vmlinuz =~ /[^-]*-(.*)/;
  
  # printf "M040 %s %s %s %s %s %s\n", $short_uuid, $device, $rootv, $set_root, $short_kernel, $vmlinuz ;

  my $erg = "";
     $erg .= "menuentry \"$short_uuid $device $rootv $set_root $short_kernel\" {\n";
     $erg .= "    recordfail\n";
     $erg .= "    load_video\n";
     $erg .= "    gfxmode \$linux_gfx_mode\n";
     $erg .= "    insmod gzio\n";
     $erg .= "    insmod ext2\n";
     $erg .= "    insmod part_gpt\n";
     $erg .= "    set root='($set_root)'\n";
     $erg .= "    search --no-floppy --fs-uuid --set=root         $uuid\n";
     $erg .= "    linux $vmlinuz root=UUID=$uuid ro noquiet nosplash\n";
     $erg .= "initrd $initrd\n";
     $erg .= "}\n";
  return $erg;
}

sub vmlinuz {
  my ($root, $directory, $DIR);
  $root = shift;
  # system "ls " . sprintf( "/%s/boot/\n", $root);
  my (@liste_vmlinuz, @liste_initrd);
  $directory = sprintf "/%s/boot", $root;
  # printf "M020 %s\n", $directory;
  opendir ($DIR, $directory) or return ""; #  or die "$directory " . $!;
  while (my $file = readdir($DIR)) {
    # printf "%s/%s\n", $directory, $file;
    #if ($file =~ m/^vmlinuz/) {
    #  # printf "%s\n", $root;
    #  push @liste_vmlinuz, sprintf( "%s %s/%s", $root, $directory, $file);
    #}
    push @liste_vmlinuz, sprintf( "%s/%s", $directory, $file) if ($file =~ m/^vmlinuz/);
    push @liste_initrd , sprintf( "%s/%s", $directory, $file) if ($file =~ m/^initrd/ );
  }
  @liste_vmlinuz = sort {$b cmp $a} @liste_vmlinuz; # reverse {$a cmp $b{ # numerically {$a <=> $b{
  @liste_initrd = sort {$b cmp $a} @liste_initrd; # reverse {$a cmp $b{ # numerically {$a <=> $b{
  my ($rootv, $vmlinuz) = $liste_vmlinuz[0] =~ m#(/[^/]*)(.*)#g;
  my ($rootr, $initrd ) = $liste_initrd [0] =~ m#(/[^/]*)(.*)#g;
  # printf "M030 %s %s %s %s\n", $rootv, $rootr, $vmlinuz, $initrd;
  
  my $erg = menuentry(
    grub_probe( "fs_uuid", $rootv),
    grub_probe( "compatibility_hint", $rootv),
    grub_probe( "device", $rootv),
    $rootv,
    $vmlinuz,
    $initrd
  );
  # printf "M050 $erg";
  return "$erg\n";

#  foreach my $elem (@liste_initrd) {
#    printf "%s\n", $elem;
#  }
}

sub menu {
  my $erg = "";
  my ($directory, $DIR);
  $directory = '/';
  # printf "%s\n", $directory;
  my @liste;
  opendir ($DIR, $directory) or die $!;
  while (my $file = readdir($DIR)) {
    next if ($file =~ m/^\./  or ! ($file =~ m/^root./) );
    #my $zu_suchen = sprintf "/%s/boot", $file;
    # printf "M010 %s\n", $file;
    # vmlinuz( $zu_suchen);
    push( @liste, $file);
  }
  @liste = sort @liste;
  foreach my $file (@liste) {
    $erg .= vmlinuz( $file);
  }
  return $erg;
}

# fstab();
sub rahmen {
  my $erg = "";
  $erg .= "#! /bin/sh -e\n";
  $erg .= "echo \"Hannos Boot-Menüeintrag 08-hanno\" >&2\n";
  $erg .= "cat << EOF\n";
  $erg .= menu();
  $erg .= "EOF\n";
  $erg .= "# $0\n";
  $erg .= "# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl  > /home/hanno/erprobe/grub-und-fstab/08-hanno-fadi\n";
  $erg .= "# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl  > /home/hanno/erprobe/grub-und-fstab/07-hanno-zoe\n";
  $erg .= "# root\@zoe:~# cp -auv /home/hanno/erprobe/grub-und-fstab/07-hanno-zoe  /etc/grub.d\n";
  $erg .= "# root\@fadi~# cp -auv /home/hanno/erprobe/grub-und-fstab/08-hanno-fadi /etc/grub.d\n";
  $erg .= "# update-grub2\n";
  $erg .= "# \n";
  print "$erg\n";
}

rahmen();

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


