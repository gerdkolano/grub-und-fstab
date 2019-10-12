#!/usr/bin/perl
# /home/hanno/erprobe/grub-und-fstab/noch-zu-erledigen.pl

use warnings;
use strict;

my $host = hostname();
my ($AUS, $dateiname);

my $SEQUENZ=15;
use Time::Piece;
my $datum = localtime->strftime("%Y-%m-%d-%H.%M.%S");
$dateiname = "$SEQUENZ-hanno-$host-$datum";

my $pfad = "/tmp/$dateiname";
print "chmod -v a-x /etc/grub.d/$SEQUENZ-*\n";
print "mv $pfad /etc/grub.d\n";
print q{dpkg -l 'linux-*' | sed '/^ii/!d;/'"$(uname -r | sed "s/\(.*\)-\([^0-9]\+\)/\1/")"'/d;s/^[^ ]* [^ ]* \([^ ]*\).*/\1/;/[0-9]/!d' # | xargs sudo apt-get -y purge};
print "\n";
print "ls -l --time-style='+%Y-%m-%d-%H-%M-%S' /boot/grub/grub.cfg | perl -ne 'while(m#([^ ]*) /boot/grub/grub.cfg#g){system \"cp -auv /boot/grub/grub.cfg /boot/grub/\$1-grub.cfg\\n\"}'\n";
print "update-grub # Das ruft grub-mkconfig -o /boot/grub/grub.cfg\n";
