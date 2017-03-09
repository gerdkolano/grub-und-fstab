#!/usr/bin/perl
# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl

use warnings;
use strict;

sub fstab {
  my ($blkid, $BLK);
  $blkid = "blkid -s LABEL -s UUID -s TYPE";
  
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

sub next_nummer {
  my $mummer;
  my $nummerspeicher = "/home/hanno/erprobe/grub-und-fstab/nummer.txt";
  
  open EIN, "< $nummerspeicher";
  while (<EIN>) {
    chop;
    $mummer=$_;
  };
  close EIN;
  
  open AUS, "> $nummerspeicher";
  # print $mummer."\n";
  printf  AUS "%06d\n", ++$mummer;
  return $mummer;
  
  close AUS;
}

my $lfd = 0;
sub eine_menuentry {
  my $uuid     = shift;
  my $set_root = shift;
  my $device   = shift;
  my $rootv    = shift;
  my $vmlinuz  = shift;
  my $initrd   = shift;
  my $datum    = shift;
  my $host     = shift;

  my $nr = sprintf "ME%06d", next_nummer();
  # printf "\$nr=%s\n", $nr;


  my $rotate   = "fbcon=rotate:3";
  use Switch;
  switch ($host) {
    case "zoe"  { $rotate   = "fbcon=rotate:3";}
    case "fadi" { $rotate   = "";}
  }

  my ($short_uuid) = $uuid =~ /(^....)/;
  my ($short_kernel) = $vmlinuz =~ /[^-]*-(.*)/;
  
  my $x1x = `/home/hanno/erprobe/grub-und-fstab/root-device.pl`;
  my $marke = "root=($device=$rootv=$short_uuid=$set_root)";
  my $kennung = "$marke $short_kernel Erzeuger=($x1x) ";
  my $erg = "";
  my $titel = "menuentry \"" . $lfd++. " $nr $kennung\"";
     printf("%s\n", "$titel");
     $erg .=        "$titel {\n";
     $erg .= "    recordfail\n";
     $erg .= "    load_video\n";
     $erg .= "    gfxmode \$linux_gfx_mode\n";
     $erg .= "    insmod gzio\n";
     $erg .= "    insmod ext2\n";
     $erg .= "    insmod part_gpt\n";
     $erg .= "    set root='($set_root)'\n";
     $erg .= "    search --no-floppy --fs-uuid --set=root         $uuid\n";
     $erg .= "    echo \"root=\$root  $uuid\"\n";
     $erg .= "    echo \"root=\$root  $uuid\"\n";
     $erg .= "    linux $vmlinuz root=UUID=$uuid $rotate ro noquiet nosplash hanno-$nr-$marke-$datum\n";
     $erg .= "initrd $initrd\n";
     $erg .= "}\n";
  return $erg;
}

sub function_vmlinuz {
  my ($root, $datum, $directory, $DIR);
  $root = shift;
  $datum = shift;
  my $host = shift;
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
  # printf( "%s\n", join(", ", @liste_vmlinuz));

  my $erg = "";

  for (my $i=0; $i<@liste_vmlinuz; $i++) {
    my ($rootv, $vmlinuz) = $liste_vmlinuz[$i] =~ m#(/[^/]*)(.*)#g;
    my ($rootr, $initrd ) = $liste_initrd [$i] =~ m#(/[^/]*)(.*)#g;
    # printf "M030 %s %s %s %s\n", $rootv, $rootr, $vmlinuz, $initrd;
    
    $erg .= eine_menuentry(
      grub_probe( "fs_uuid", $rootv),
      grub_probe( "compatibility_hint", $rootv),
      grub_probe( "device", $rootv),
      $rootv,
      $vmlinuz,
      $initrd,
      $datum,
      $host
    );
  }
  # printf "M050 $erg";
  return "$erg\n";

#  foreach my $elem (@liste_initrd) {
#    printf "%s\n", $elem;
#  }
}

sub das_menu {
  my $datum = shift;
  my $host = shift;

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
    $erg .= function_vmlinuz( $file, $datum, $host);
  }
  return $erg;
}

sub erzeuge_menuentries {
  my $AUS       = shift;
  my $dateiname = shift;
  my $datum     = shift;
  my $host      = shift;

  my $default   = "0";
  use Sys::Hostname;
  use Switch;
  switch ($host) {
    case "zoe"  { $default   = "3";}
    case "fadi" { $default   = "6";}
  }

  my $erg = "";
  $erg .= "#! /bin/sh -e\n";
  $erg .= "echo \"Hannos Boot-Menüeintrag $dateiname\" >&2\n";
  $erg .= "cat << EOF\n";
  $erg .= "# set default=\"$default\"\n";
  $erg .= "### hanno ### Die Nummerierung beginnt bei 0\n";
  $erg .= das_menu( $datum, $host);
  $erg .= "EOF\n";
  $erg .= "# $0\n";

  $erg .= "# Vereinfacht :\n";
  $erg .= "# 1) Editiere /etc/grub.d/$dateiname,  z.B s/-86-/-87-/\n";
  $erg .= "# 2) update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg\n";
  $erg .= "# 3) init 6\n";
  $erg .= "# \n";
  $erg .= "# /home/hanno/erprobe/grub-und-fstab/erzeuge-menu.pl\n";
  $erg .= "# root\@zoe:~# cp -auv $dateiname /etc/grub.d\n";
  $erg .= "# root\@fadi:~# cp -auv $dateiname /etc/grub.d\n";
  $erg .= "# root\@zoe~# update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg\n";
  $erg .= "# root\@fadi~# update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg\n";
  $erg .= "# \n";
  $erg .= "# \n";
  print $AUS "$erg\n";
}

if ($> > 0) {
  print "uid == $> . Nur root kann das.<br />\n";
  exit 1;
}
fstab();

my $host = hostname();
my ($AUS, $dateiname);

my $SEQUENZ=15;
use Time::Piece;
my $datum = localtime->strftime("%Y-%m-%d-%H.%M.%S");
$dateiname = "$SEQUENZ-hanno-$host-$datum";

my $pfad = "/tmp/$dateiname";
open $AUS, "> $pfad";
erzeuge_menuentries( $AUS, $dateiname, $datum, $host);
close $AUS;
chmod 0755, $pfad;

print "Noch zu erledigen:\n";
print "chmod -v a-x /etc/grub.d/$SEQUENZ-*\n";
print "mv $pfad /etc/grub.d\n";
print q{dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' # | xargs sudo apt-get -y purge};
print "\n";
#print q{perl -pne 's#x1x#'"`/home/hanno/erprobe/grub-und-fstab/root-device.pl`"'#' /boot/grub/grub.cfg > /tmp/1 && mv /tmp/1 /boot/grub/grub.cfg};
#print "\n";

print "update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg\n";
print "\n";

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


