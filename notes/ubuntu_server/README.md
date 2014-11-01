
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
4. From the console verify **Install Ubuntuerver with Custom Config** is selected. Press Enter
5. TODO: Install stops at the 'Configure the network' screen.  Select the appropriate interface and press Enter.
For controller and network nodes select p2p1 network interface (add ksdevice=p2p1 to boot options)
For compute and storage nodes select eth0 
6. TODO: Install stops at the 'Partition disks' screen.  Hit the left-arrow to select Yes and press Enter.
7. DVD is ejected from the DVDROM.  System reboots and loads OS from /dev/sda.
8. The console appears with the board-serial-number as the hostname.
9. Login and verify connectivity

- Goes to Detected existing mount - enter to unmount
- Goes to red Partition disks screen : Unable o automatically remove LVM data

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

References:

[https://help.ubuntu.com/community/KickstartCompatibility]
[http://askubuntu.com/questions/457528/how-do-i-create-an-efi-bootable-iso-of-a-customized-version-of-ubuntu]
[http://askubuntu.com/questions/122505/how-do-i-create-a-completely-unattended-install-of-ubuntu]


