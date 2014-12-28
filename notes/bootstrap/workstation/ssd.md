
#### SSD

- Check if SSD has discard support: `cat /sys/block/sda/queue/discard_granularity`
- Setup `dofstrim.sh` to execute once a week to trim the disk
- Add `noatime` to /etc/fstab

```
cp /home/devops/git/juno-saltstack/files/workstation/bin/dofstrim.sh /root/

crontab -e
## Run every Saturday at 06:00
0 6 * * 6 /root/dofstrim.sh > /root/dofstrim.out 2>&1

[root@workstation2 ~]# 
[root@workstation2 ~]# cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sat Dec 27 21:36:56 2014
#
# Accessible filesystems, by reference, are maintained under '/dev/disk'
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info
#
UUID=0c72ca59-f942-4b8f-8221-20bb370d4865 /                       xfs     rw,noatime,nobarrier        1 1
UUID=2726cf71-0eb1-4a8b-8024-c2c632cc8191 /boot                   xfs     defaults        1 2
UUID=a2ce59e0-d42f-4773-b787-849773ece2d9 swap                    swap    defaults        0 0
[root@workstation2 ~]# 

[root@workstation2 ~]# vi /etc/sysctl.conf 
[root@workstation2 ~]# sysctl -p
vm.swappiness = 1
vm.vfs_cache_pressure = 50

[root@workstation2 ~]# cat /sys/block/sda/queue/scheduler
noop deadline [cfq] 

```
Add `elevator=deadline` to the end of GRUB_CMDLINE_LINUX in /etc/default/grub
```
grub2-mkconfig -o /boot/grub2/grub.cfg
```

##### References

[http://blog.neutrino.es/2013/howto-properly-activate-trim-for-your-ssd-on-linux-fstrim-lvm-and-dmcrypt/]
[https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-ssd.html]
[http://jensd.be/?p=1]
[http://www.certdepot.net/rhel7-extend-life-ssd/]
[http://www.phoronix.com/scan.php?page=article&item=linux_316_iosched&num=1]
[http://fsi-viewer.blogspot.com/2011/10/filesystem-benchmarks-part-i.html]



