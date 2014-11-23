
[root@block1 ~]$ lsblk
NAME              MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINT
sda                 8:0    0 279.5G  0 disk  
└─sda1              8:1    0 279.5G  0 part  
sdb                 8:16   0 279.5G  0 disk  
sdc                 8:32   0  74.5G  0 disk  
├─sdc1              8:33   0  66.6G  0 part  
│ └─md126           9:126  0  66.5G  0 raid1 
│   ├─centos-swap 253:0    0   3.9G  0 lvm   [SWAP]
│   └─centos-root 253:1    0  62.5G  0 lvm   /
└─sdc2              8:34   0   512M  0 part  
  └─md127           9:127  0   512M  0 raid1 /boot
sdd                 8:48   0  74.5G  0 disk  
├─sdd1              8:49   0  66.6G  0 part  
│ └─md126           9:126  0  66.5G  0 raid1 
│   ├─centos-swap 253:0    0   3.9G  0 lvm   [SWAP]
│   └─centos-root 253:1    0  62.5G  0 lvm   /
└─sdd2              8:50   0   512M  0 part  
  └─md127           9:127  0   512M  0 raid1 /boot
[root@block1 ~]$ blkid
/dev/sdc1: UUID="c96ae38f-b614-5743-b25f-152ba7c42ce9" UUID_SUB="e7fbc369-f253-7d7e-ea79-4766c99f944b" LABEL="localhost:pv00" TYPE="linux_raid_member" 
/dev/sdc2: UUID="865f36dc-81df-7c24-ee3e-9f635e4c1277" UUID_SUB="b2f2f203-86e0-e5c0-adff-ae4dfeed53db" LABEL="localhost:boot" TYPE="linux_raid_member" 
/dev/sdd1: UUID="c96ae38f-b614-5743-b25f-152ba7c42ce9" UUID_SUB="2bd56d34-048c-afd5-6ce4-2cc41284b5d3" LABEL="localhost:pv00" TYPE="linux_raid_member" 
/dev/sdd2: UUID="865f36dc-81df-7c24-ee3e-9f635e4c1277" UUID_SUB="503d2d17-6622-b6ec-fa67-91eff4815e92" LABEL="localhost:boot" TYPE="linux_raid_member" 
/dev/sda1: UUID="1776f96b-8526-7aa9-28f7-d65e43a63541" UUID_SUB="02438ef7-0eca-3457-e03c-e7a3a1f71835" LABEL="localhost:1" TYPE="linux_raid_member" 
/dev/md127: UUID="81181273-9fc4-4593-9b78-72b786385294" TYPE="xfs" 
/dev/md126: UUID="h13xmy-2l1I-iqS9-kcsW-X6dk-LOYg-Jp2omI" TYPE="LVM2_member" 
/dev/mapper/centos-swap: UUID="d6958c53-573e-44ac-9d12-1fd3c597aba2" TYPE="swap" 
/dev/mapper/centos-root: UUID="b62554f3-d1e9-47e5-bd68-3d969ccb3d4e" TYPE="xfs" 
/dev/sdb: PTTYPE="dos" 
[root@block1 ~]$ pvdisplay
  No device found for PV aDKrW6-xRCU-6b1l-cISL-vmBa-iTeR-rT4v3B.
  --- Physical volume ---
  PV Name               /dev/md126
  VG Name               centos
  PV Size               66.49 GiB / not usable 3.88 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              17020
  Free PE               31
  Allocated PE          16989
  PV UUID               h13xmy-2l1I-iqS9-kcsW-X6dk-LOYg-Jp2omI
   
[root@block1 ~]$ lvdisplay
  No device found for PV aDKrW6-xRCU-6b1l-cISL-vmBa-iTeR-rT4v3B.
  --- Logical volume ---
  LV Path                /dev/centos/swap
  LV Name                swap
  VG Name                centos
  LV UUID                jO6xi7-Lhit-PF3K-hB5Y-kHSq-tIRV-rfG68b
  LV Write Access        read/write
  LV Creation host, time localhost, 2014-11-07 07:11:33 -0500
  LV Status              available
  # open                 2
  LV Size                3.87 GiB
  Current LE             990
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:0
   
  --- Logical volume ---
  LV Path                /dev/centos/root
  LV Name                root
  VG Name                centos
  LV UUID                snuvTH-0cej-uNjK-7Cwt-gqnH-peRa-3WFgob
  LV Write Access        read/write
  LV Creation host, time localhost, 2014-11-07 07:11:34 -0500
  LV Status              available
  # open                 1
  LV Size                62.50 GiB
  Current LE             15999
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:1
   
[root@block1 ~]$ lvmdiskscan
  /dev/sda         [     279.46 GiB] LVM physical volume
  /dev/centos/swap [       3.87 GiB] 
  /dev/centos/root [      62.50 GiB] 
  /dev/sdb         [     279.46 GiB] 
  /dev/md126       [      66.49 GiB] LVM physical volume
  /dev/md127       [     511.94 MiB] 
  3 disks
  1 partition
  1 LVM physical volume whole disk
  1 LVM physical volume
[root@block1 ~]$ 

