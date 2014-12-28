
#### SSD

- Check if SSD has discard support: `cat /sys/block/sda/queue/discard_granularity`

```
[root@workstation2 ~]# cat /root/dofstrim.sh
#!/bin/sh

# this cronjob will discard unused blocks on the ssd mounted filesystems

# get the locally mounted block devices - those starting with "/dev:
# run df -k, pipe the result through grep and save the sixth field in
# in the mountpoint array
mountpoint=( $(df -k | grep ^/dev | awk '{print $6}') )

# loop through the array and run fstrim on every mountpoint
for i in "${mountpoint[@]}"
do
/usr/sbin/fstrim -v $i;
done
echo "fstrim ran `date`"

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
UUID=0c72ca59-f942-4b8f-8221-20bb370d4865 /                       xfs     noatime        1 1
UUID=2726cf71-0eb1-4a8b-8024-c2c632cc8191 /boot                   xfs     noatime        1 2
UUID=a2ce59e0-d42f-4773-b787-849773ece2d9 swap                    swap    defaults        0 0
[root@workstation2 ~]# 
```

##### References

[http://blog.neutrino.es/2013/howto-properly-activate-trim-for-your-ssd-on-linux-fstrim-lvm-and-dmcrypt/]
[https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Storage_Administration_Guide/ch-ssd.html]



