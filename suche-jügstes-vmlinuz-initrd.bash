#!/bin/bash

for n in /root?/boot ; do echo "################ $n"; ls $n/vmlinuz* | tail -1; ls $n/init* | tail -1;done
