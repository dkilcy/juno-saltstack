#version=RHEL7

# the Setup Agent is not started the first time the system boots
firstboot --disable

# text mode (no graphical mode)
text
# do not configure X
skipx
# non-interactive command line mode
cmdline
# install
install

# network
network --bootproto=dhcp --device=enp0s20f0 --ipv6=auto --activate

# installation path
url --url=http://10.0.0.6/repo/centos/7/os/x86_64
# repository
repo --name="CentOS Base"   --baseurl=http://10.0.0.6/repo/centos/7/os/x86_64
repo --name="CentOS Update" --baseurl=http://10.0.0.6/repo/centos/7/updates/x86_64

# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8
# timezone
timezone --utc UTC

# root password
rootpw scality
# System authorization information
auth --enableshadow --passalgo=sha512

# SElinux
selinux --disabled
# firewall
firewall --disabled

# bootloader
bootloader --location=mbr --boot-drive=sda
# clear the MBR (Master Boot Record)
zerombr
# do not remove any partition (preserve the gpt label)
clearpart --none

# Disk partitioning information
part /boot --fstype="ext4" --ondisk=sda --size=512
part swap --fstype="swap" --ondisk=sda --size=4096
part / --fstype="ext4" --ondisk=sda --size=1 --grow

part /scality/disk1 --fstype="ext4" --ondisk=sdb --size=1 --grow
part /scality/disk2 --fstype="ext4" --ondisk=sdc --size=1 --grow

# Reboot
reboot --eject

################################################################################
%pre
parted -s /dev/sda mklabel gpt
parted -s /dev/sdb mklabel gpt
parted -s /dev/sdc mklabel gpt

%end
################################################################################
%packages --nobase --ignoremissing
@core --nodefaults
-aic94xx-firmware*
-alsa-*
-avahi
-biosdevname
-btrfs-progs*
-dhcp*
-dracut-network
-iprutils
-ivtv*
-iwl*firmware
-kexec-tools
-libertas*
-plymouth*
-postfix
-ModemManager*
-NetworkManager*
-wpa_supplicant
dstat
gparted
hdparm
htop
iotop
iozone
iperf3
keyutils
lshw
net-snmp
net-snmp-libs
net-snmp-perl.x86_64
net-snmp-utils.x86_64
openssh-clients
parted
pciutils
rsync
tcpdump
telnet
traceroute
vim-enhanced
wget
yum-utils
zip
%end

%end
################################################################################
%post
# cleanup the installation
yum -y clean all

%end
################################################################################
