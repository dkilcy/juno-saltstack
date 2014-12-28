### Workstation Setup

##### Tasks:

1. Install CentOS 7 GNOME desktop on Workstation  
  - Set the hostname if not already done: ` hostnamectl set-hostname workstation2.pub`

2. Set security policies as root

```
setenforce 0
systemctl stop iptables.service
systemctl disable iptables.service
```

3. Disable network manager
```
[devops@workstation2 juno-saltstack]$ cat /etc/sysconfig/network-scripts/ifcfg-enp5s0 
TYPE=Ethernet
BOOTPROTO=none
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=no
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=enp5s0
UUID=c8a39db7-76d4-438a-9a5f-d27b66089bbe
ONBOOT=yes
IPADDR0=192.168.1.6
PREFIX0=24
GATEWAY0=192.168.1.1
DNS1=192.168.1.1
HWADDR=00:01:C0:14:87:40


[devops@workstation2 juno-saltstack]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s25 
HWADDR=00:01:C0:14:87:37
TYPE=Ethernet
BOOTPROTO=none
IPV6INIT=no
NAME=enp0s25
UUID=5bcd49c8-a3c0-4440-ac5b-ea2d70947a6d
ONBOOT=yes
IPADDR=10.0.0.6
NETMASK=255.255.255.0


systemctl stop NetworkManager.service
systemctl disable NetworkManager.service
service network restart
```

Allow devops user to sudo without a password
```
visudo
devops   ALL=(ALL)       NOPASSWD: ALL
```

3. Configure GitHub and pull juno-saltstack as devops user

```
yum install git
su - devops
mkdir ~/git ; cd ~/git
git clone https://github.com/dkilcy/juno-saltstack.git
```   

4. Set the hosts file as root

```
mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/hosts /etc/hosts
```   

5. Add the EPEL and OpenStack repositories  
```
yum install -y yum-plugin-priorities
yum install epel-release
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y
```   

6. Create the repository mirror  
```
cp /home/devops/git/juno-saltstack/files/workstation/bin/reposync.sh /root
crontab -e
crontab -l
0 4 * * * /root/reposync.sh > /root/reposync.out 2>&1

cd /root
./reposync.sh

sed -i "s/gpgcheck=1/gpgcheck=1\nenabled=0/g" /etc/yum.repos.d/CentOS-Base.repo
cp /home/devops/git/juno-saltstack/files/workstation/etc/yum.repos.d/local.repo /etc/yum.repos.d/local.repo

yum clean all
yum update
yum grouplist
```

7. Setup apache  
```
yum install -y httpd
systemctl start httpd
systemctl enable httpd

ln -s /var/yum/repo /var/www/html/repo
cp /home/devops/git/juno-saltstack/files/workstation/etc/yum.repos.d/local.repo /var/www/html/repo/
cp /etc/hosts /var/www/html/repo/
```
  - SELinux policy: `grep httpd /var/log/audit/audit.log | audit2allow -M mypol; semodule -i mypol.pp`
  

1. Install additional software
```
yum -y install \
git \
gparted \
hdparm \
htop \
iperf3 \
lshw \
minicom \
ntp
```
8. Setup NTPD  
```
yum install -y ntp
systemctl start ntpd.service
systemctl enable ntpd.service
ntpq -p
```

10. Setup salt master  
```
yum -y install salt-master

ln -s /home/devops/git/juno-saltstack/salt /srv/salt
ln -s /home/devops/git/juno-saltstack/reactor /srv/reactor
ln -s /home/devops/git/juno-saltstack/pillar /srv/pillar

systemctl restart salt-master
systemctl enable salt-master
```

11. Install MATE Desktop
```
yum groups install "MATE Desktop"
```

  If installing from minimal:
  ```
  yum groups install "X-Windows-System"
  systemctl set-default graphical.target
  ```

9. Setup DHCP server
```
yum install -y dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd.service
systemctl enable dhcpd.service
```
 
