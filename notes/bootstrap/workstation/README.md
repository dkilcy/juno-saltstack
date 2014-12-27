### Workstation Setup

##### Tasks:

  1. [] Install CentOS 7 GNOME Desktop
  2. [] Set security policies
  3. [] Configure GitHub and pull juno-saltstack
  4. [] Set the hosts file
  5. [] Add the EPEL and OpenStack repositories
  6. [] Create the repository mirror
  7. [] Setup apache
  8. [] Setup NTPD
  9. [] Setup DHCP server
  10. [] Setup salt master
  11. [] Create the kickstart image for nodes

#### Steps

1. Install CentOS 7 GNOME desktop on Workstation  
- Set the hostname if not already done: ` hostnamectl set-hostname workstation2.pub`

2. Set security policies as root
```
setenforce 0
systemctl stop iptables.service
systemctl disable iptables.service
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
[root@workstation2 ~]# crontab -l
0 4 * * * /root/reposync.sh > /root/reposync.out 2>&1


sed "s/gpgcheck=1/gpgcheck=1\nenabled=0/g" /etc/yum.repos.d/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
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
```

8. Setup NTPD  
```
systemctl start ntpd
systemctl enable ntpd
ntpq -p
```

9. Setup DHCP server   
```
yum install -y dhcp
mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/juno-saltstack/files/workstation/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf
systemctl start dhcpd
systemctl enable dhcpd
```

10. Setup salt master  
```
yum install salt-master

cd srv
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/salt .
ln -s /home/devops/git/juno-saltstack/pillar .

systemctl restart salt-master
systemctl enable salt-master
```

11. Create the kickstart image for nodes  

12. 
