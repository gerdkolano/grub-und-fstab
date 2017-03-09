#!/usr/bin/perl
use warnings;
use strict;

my $nr;
my $nummerspeicher = "/home/hanno/erprobe/grub-und-fstab/nummer.txt";

open EIN, "< $nummerspeicher";
while (<EIN>) {
  chop;
  $nr=$_;
};
close EIN;

open AUS, "> $nummerspeicher";
print $nr."\n";
printf  AUS "%06d\n", ++$nr;

close AUS;
