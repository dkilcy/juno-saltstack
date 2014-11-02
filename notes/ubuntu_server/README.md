
### Ubuntu Server 14.04.1 setup

Create a bootable DVD t with a custom image to automate the install as much as possible
Deploy th custom image to all the OpenStack nodes.

##### Create a custom Ubuntu Server 14.04 image 

```
sudo -i

cd staging

wget http://releases.ubuntu.com/14.04/ubuntu-14.04.1-server-amd64.iso
mkdir iso_in iso_out
sudo mount -o loop ubuntu-14.04.1-server-amd64.iso iso_in
cp -rT iso_in/ iso_out/

cd iso_out

echo en > isolinux/lang

vi ks.preseed
vi ks.cfg
vi boot/grub/grub.cfg
vi isolinux/txt.cfg 

sudo mkisofs -U -A "Custom1404" -V "Custom1404" -volset "Custom1404" -J -joliet-long -r -v -T -o ../Custom1404.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot .
```

##### Compare the results

```
dumpet -i Custom1404.iso
dumpet -i ubuntu-14.04.1-server-amd64.iso
```

##### Burn the ISO 

Start Brasero burner and burn the Custom1404.iso to media

### Install custom Ubuntu 14.04 image on Supermicro 

Prereq:
The node is powered off.
one (and only one) of the mgmt interface(s) is plugged into the switch.

2. Plug the DVDROM into the blue USB port and insert the media
3. Power up the Supermicro. It will detect the DVDROM and boot from it.  If it doesn't hit F11 to set the boot device.
4. From the console verify **Install Ubuntu Server with Custom Config** is selected. Press Enter
5. TODO: Install stops at the 'Configure the network' screen.  Select the appropriate interface and press Enter.
For controller and network nodes select p2p1 network interface (add ksdevice=p2p1 to boot options)
For compute and storage nodes select eth0 
7. DVD is ejected from the DVDROM.  System reboots and loads OS from /dev/sda.
8. The console appears with the board-serial-number as the hostname.
9. Login and verify connectivity

If there are existing partitions, the install will stop for input after step 5
- Goes to Detected existing mount - enter to unmount
- Goes to red Partition disks screen : Unable o automatically remove LVM data

Use GParted Live media to destroy any existing partitions and retry.

##### Notes

Alt-Function keys switch between TTYs:

1. Alt+F1 - Installer dialog
2. Alt+F2 - shell
3. Alt+F3 - shell
4. Output of syslog: tail -f /var/log/syslog

```
# apt-get remove hwdata
# wget ftp://mirror.ovh.net/mirrors/ftp.debian.org/debian/pool/main/h/hwdata/hwdata_0.234-1_all.deb
# dpkg -i hwdata_0.234-1_all.deb
# apt-get install system-config-kickstart
# system-config-kickstart

# apt-get install tasksel

devops@workstation3:~$ sudo tasksel --list-tasks
```

#### Notes


Import the OpenStack package key and the SaltStack key
```
root@NM13CS010012:~# apt-get install ubuntu-cloud-keyring
Reading package lists... Done
Building dependency tree       
Reading state information... Done
The following packages were automatically installed and are no longer required:
  git git-man liberror-perl libjs-jquery python-async python-git python-gitdb
  python-smmap
Use 'apt-get autoremove' to remove them.
The following NEW packages will be installed:
  ubuntu-cloud-keyring
0 upgraded, 1 newly installed, 0 to remove and 3 not upgraded.
Need to get 5,086 B of archives.
After this operation, 34.8 kB of additional disk space will be used.
Get:1 http://10.0.0.7/ubuntu/ trusty/universe ubuntu-cloud-keyring all 2012.08.14 [5,086 B]
Fetched 5,086 B in 0s (30.1 kB/s)                 
Selecting previously unselected package ubuntu-cloud-keyring.
(Reading database ... 60425 files and directories currently installed.)
Preparing to unpack .../ubuntu-cloud-keyring_2012.08.14_all.deb ...
Unpacking ubuntu-cloud-keyring (2012.08.14) ...
Setting up ubuntu-cloud-keyring (2012.08.14) ...
Importing ubuntu-cloud.archive.canonical.com keyring
OK
Processing ubuntu-cloud.archive.canonical.com removal keyring
gpg: /etc/apt/trustdb.gpg: trustdb created
OK
root@NM13CS010012:~# wget -q -O- "http://10.0.0.7/saltstack-salt.gpg" | apt-key add - 
OK
```

##### References

[https://help.ubuntu.com/community/KickstartCompatibility]  
[http://askubuntu.com/questions/457528/how-do-i-create-an-efi-bootable-iso-of-a-customized-version-of-ubuntu]  
[http://askubuntu.com/questions/122505/how-do-i-create-a-completely-unattended-install-of-ubuntu]  


