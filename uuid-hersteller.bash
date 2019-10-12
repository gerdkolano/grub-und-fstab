#!/bin/bash

ls -l /dev/disk/by-path | perl -ne 'if(m#(pci-[^ ]*) -> ../../(.*)#){printf "%s %s\n",$2, $1}'    | sort > /tmp/path
ls -l /dev/disk/by-uuid | perl -ne 'if(m#(.{8}-[^ ]*) -> ../../(.*)#){printf "%s %s\n",$2, $1}'    | sort > /tmp/uuid
ls -l /dev/disk/by-id   | perl -ne 'if(m#(?:ata-)([^ ]*) -> ../../(.*)#){printf "%s %s\n",$2, $1}' | sort > /tmp/id

#oin --nocheck-order /tmp/id      /tmp/uuid 2>/dev/null > /tmp/id-uuid
#oin --nocheck-order /tmp/id-uuid /tmp/path 2>/dev/null

join --nocheck-order /tmp/uuid    /tmp/path 2>/dev/null > /tmp/id-uuid
join --nocheck-order /tmp/id-uuid /tmp/id   2>/dev/null

exit 0

# for i in a s o  q  ; do e=`grub-probe --target=compatibility_hint /root$i; grub-probe --target=device /root$i; grub-probe --target=fs_uuid /root$i`;echo $e;done

# dmesg | grep ' ata'
#   
zwei parallele           [    1.756957] ata1: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
Anschlüsse               [    1.757007] ata2: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
vier serielle            [    1.769452] ata3: SATA max UDMA/133 abar m1024@0xf5cff800 port 0xf5cff900 irq 22
Anschlüsse               [    1.769507] ata4: SATA max UDMA/133 abar m1024@0xf5cff800 port 0xf5cff980 irq 22
                         [    1.769570] ata5: SATA max UDMA/133 abar m1024@0xf5cff800 port 0xf5cffa00 irq 22
                         [    1.769627] ata6: SATA max UDMA/133 abar m1024@0xf5cff800 port 0xf5cffa80 irq 22
                         
DVD             /dev/sr  [    1.926572] ata1.00: ATAPI: HL-DT-ST DVDRAM GH22NS40, NL02, max UDMA/100

                /dev/sda [    1.926932] ata1.01: ATA-8: ST4000DM000-1F2168, CC52, max UDMA/133
                         [    1.926980] ata1.01: 7814037168 sectors, multi 16: LBA48 NCQ (depth 0/1)
                         [    1.942509] ata1.00: configured for UDMA/100
                         [    1.958779] ata1.01: configured for UDMA/100
                         
HD                       [    2.442990] ata3.00: supports DRM functions and may not be fully accessible
                /dev/sdb [    2.443070] ata3.00: ATA-10: CT1000MX500SSD1, M3CR020, max UDMA/133
                         [    2.443117] ata3.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
                         [    2.443464] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
                         [    2.443636] ata3.00: supports DRM functions and may not be fully accessible
                         [    2.443862] ata3.00: SB600 AHCI: limiting to 255 sectors per cmd
                         [    2.443909] ata3.00: configured for UDMA/133
                         
HD                       [    2.452147] ata5.00: ATA-10: ST10000VN0004-1ZD101, SC60, max UDMA/133
                /dev/sdc [    2.452197] ata5.00: 19532873728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
                         [    2.452251] ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
                         
HD                       [    2.452671] ata6.00: ATA-10: ST10000VN0004-1ZD101, SC60, max UDMA/133
                /dev/sdd [    2.452719] ata6.00: 19532873728 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
                         [    2.452773] ata6.00: SB600 AHCI: limiting to 255 sectors per cmd
                         
                         [    2.454938] ata5.00: SB600 AHCI: limiting to 255 sectors per cmd
                         [    2.454986] ata5.00: configured for UDMA/133
                         [    2.455368] ata6.00: SB600 AHCI: limiting to 255 sectors per cmd
                         [    2.455417] ata6.00: configured for UDMA/133
#   

dmesg | grep '\[    .\.......\] scsi'
                         [    1.754121] scsi host0: pata_atiixp
                         [    1.756847] scsi host1: pata_atiixp
                         [    1.768674] scsi host2: ahci
                         [    1.769043] scsi host3: ahci
                         [    1.769189] scsi host4: ahci
                         [    1.769339] scsi host5: ahci
                /dev/sr  [    1.967982] scsi 0:0:0:0: CD-ROM            HL-DT-ST DVDRAM GH22NS40  NL02 PQ: 0 ANSI: 5
                /dev/sda [    1.992153] scsi 0:0:1:0: Direct-Access     ATA      ST4000DM000-1F21 CC52 PQ: 0 ANSI: 5
                /dev/sdb [    2.444115] scsi 2:0:0:0: Direct-Access     ATA      CT1000MX500SSD1  020  PQ: 0 ANSI: 5
                /dev/sdc [    2.455202] scsi 4:0:0:0: Direct-Access     ATA      ST10000VN0004-1Z SC60 PQ: 0 ANSI: 5
                /dev/sdd [    2.455984] scsi 5:0:0:0: Direct-Access     ATA      ST10000VN0004-1Z SC60 PQ: 0 ANSI: 5
                         [    3.328513] scsi host6: usb-storage 1-1.1:1.0
                         [    4.327168] scsi 6:0:0:0: CD-ROM            FRITZ!   WLAN selfinstall 1.00 PQ: 0 ANSI: 0 CCS


bios pata1 scsi 0:0:0:0: ata1.00
bios pata2 scsi 0:0:1:0: ata1.01
bios sata1 scsi 2:0:0:0: ata3.00 motherboard rot
bios sata2 scsi 3:0:0:0: ata4.00 motherboard gelb
bios sata3 scsi 4:0:0:0: ata5.00 motherboard schwarz
bios sata4 scsi 5:0:0:0: ata6.00 motherboard blau

