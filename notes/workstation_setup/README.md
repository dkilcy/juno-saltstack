
## Workstation setup

The workstation acts in the capacity of the utility node in OpenStack

This document explains the steps to:
1. Install the OS from DVD
2. Setup static networking
3. Setup the apt mirror
4. Configure DHCP
5. 

### Install Ubuntu Desktop 14.04.1 on workstation node

### Post-Install configuraton steps

#### Disable automatic network management

```
sudo service network-manager stop
sudo apt-get remove network-manager network-manager-gnome
```

Contents of /etc/network/interfaces
```
# interfaces(5) file used by ifup(8) and ifdown(8)
auto lo
iface lo inet loopback

auto eth0
iface eth0 inet static
address 10.0.0.7
netmask 255.255.255.0
#gateway 10.0.0.1
dns-search mgmt vm

auto eth1
iface eth1 inet static
address 192.168.1.7
netmask 255.255.255.0
gateway 192.168.1.1
dns-search pub
dns-nameservers 192.168.1.1

```

##### Enable the interfaces

```
sudo ifdown eth0
sudo ifup eth0
sudo ifdown eth1
sudo ifup eth1

```

Verify the changes were made to /etc/resolv.conf
Remove 127.0.1.1 from /etc/hosts

Contents of /etc/hosts
```
127.0.0.1	localhost

###############################################################################
# Network:
# *.mgmt - OpenStack Internal Network
# *.pub - Public Network
# *.vm - VM Traffic Network
###############################################################################
10.0.0.5 workstation1.mgmt workstation1
10.0.0.6 workstation2.mgmt workstation2
10.0.0.7 workstation3.mgmt workstation3 salt ntp

10.0.0.11 controller1.mgmt controller1 controller
10.0.0.12 controller2.mgmt controller2

10.0.0.21 network1.mgmt network1 network
10.0.0.22 network2.mgmt network2

10.0.0.31 compute1.mgmt compute1
10.0.0.32 compute2.mgmt compute2
10.0.0.33 compute3.mgmt compute3
10.0.0.34 compute4.mgmt compute4

10.0.0.41 block1.mgmt block1
10.0.0.42 block2.mgmt block2
10.0.0.43 block3.mgmt block3
10.0.0.44 block4.mgmt block4

10.0.0.51 object1.mgmt object1
10.0.0.52 object2.mgmt object2
10.0.0.53 object3.mgmt object3
10.0.0.54 object4.mgmt object4
10.0.0.55 object5.mgmt object5

10.0.1.31 compute1.vm
10.0.1.32 compute2.vm
10.0.1.33 compute3.vm
10.0.1.34 compute4.vm

192.168.1.5 workstation1.pub
192.168.1.6 workstation2.pub
192.168.1.7 workstation3.pub

192.168.1.11 controller1.pub
192.168.1.12 controller2.pub
```


##### Test the connection
```
devops@workstation3 ~ $ ping openstack.org -c 4
PING openstack.org (192.237.193.83) 56(84) bytes of data.
64 bytes from 192.237.193.83: icmp_seq=1 ttl=248 time=44.0 ms
64 bytes from 192.237.193.83: icmp_seq=2 ttl=248 time=45.1 ms
64 bytes from 192.237.193.83: icmp_seq=3 ttl=248 time=43.8 ms
64 bytes from 192.237.193.83: icmp_seq=4 ttl=248 time=45.2 ms

--- openstack.org ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3003ms
rtt min/avg/max/mdev = 43.856/44.574/45.264/0.691 ms
devops@workstation3 ~ $ 
```

##### Change the logical name of the interfaces

Edit /etc/udev/rules.d/70-persistent-net.rules 

#### Setup the repository mirror
```
sudo apt-get update
sudo apt-get dist-upgrade
reboot now

sudo add-apt-repository cloud-archive:juno
```

```
sudo apt-get install -y apache2 apt-mirror

vi /etc/apt/mirror.list
deb http://ubuntu-cloud.archive.canonical.com/ubuntu trusty-updates/juno main

sudo apt-mirror

sudo apt-get install apache2

sudo ln -s /var/spool/apt-mirror/mirror/archive.ubuntu.com/ubuntu /var/www/html/ubuntu
sudo ln -s /var/spool/apt-mirror/mirror/ubuntu-cloud.archive.canonical.com/ubuntu /var/www/html/openstack-juno

```

### DHCP Server setup

sudo apt-get install isc-dhcp-server -y

vi /etc/default/isc-dhcp-server
vi /etc/dhcp/dhcpd.conf

service isc-dhcp-server restart

### Discovering MAC addresess on network

sudo apt-get install nmap
sudo nmap -O 10.0.0.0/24

References:

[http://www.unixmen.com/setup-dhcp-server-ubuntu-14-04-lts-server/]
[http://www.linux.com/learn/tutorials/470979-who-and-what-is-on-my-network-probing-your-network-with-linux]
[http://www.unixmen.com/setup-local-repository-ubuntu-14-0413-1013-04-server/]
[http://unixrob.blogspot.com/2012/05/create-apt-mirror-with-ubuntu-1204-lts.html]




