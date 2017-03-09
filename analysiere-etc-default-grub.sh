perl -e 'while(<>){s/(^[^#]*)(#.*)/$1/;{while(m#(^.*GRUB_[^=]*=.*)#g){print "$1\n"}}}' /etc/default/grub
