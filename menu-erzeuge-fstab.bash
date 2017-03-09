#!/bin/bash

blkid | perl -ne '$l="";while(m#(UUID=)"([^"]*)#g){$u="$1$2"};while(m#(LABEL=)"([^"]*)#g){$l="$2"};while(m#(TYPE=)"([^"]*)#g){$t="$2"};$l=($l eq ""?"      ":"/$l");print "$u $l ext4 rw,nosuid,nodev,uhelper=devkit 1 2\n" if $t eq "ext4";print "$u none   swap sw                             0 0\n" if $t eq "swap";' > /tmp/fstab

