ls -l /dev/disk/by-uuid | perl -ne 'if(m#(.{8}-[^ ]*) -> ../../(.*)#){printf "%s %s\n",$2, $1}'
