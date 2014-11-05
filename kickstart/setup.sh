# run as root user

setenforce 0
systemctl stop firewalld
systemctl disable firewalld

mkdir -p /home/devops/git
chown devops.devops /home/devops/git

cd /home/devops/git
git clone https://github.com/dkilcy/juno-saltstack.git
chown -R devops.devops /home/devops/git

cd ~

### Set /etc/hostname 

mv /etc/hosts /etc/hosts.`date +%s`
cp /home/devops/git/juno-saltstack/kickstart/etc/hosts /etc/hosts

### Add EPEL and OpenStack repository

yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y

### Create repo mirror

mkdir -p /data/repo/centos/7/x86_64/base
mkdir -p /data/repo/centos/7/x86_64/updates
mkdir -p /data/repo/centos/7/x86_64/extras
mkdir -p /data/repo/centos/7/x86_64/epel
mkdir -p /data/repo/centos/7/x86_64/openstack-juno

createrepo /data/repo/centos/7/x86_64/base
createrepo /data/repo/centos/7/x86_64/updates
createrepo /data/repo/centos/7/x86_64/extras
createrepo /data/repo/centos/7/x86_64/epel
createrepo /data/repo/centos/7/x86_64/openstack-juno

reposync -p /data/repo/centos/7/x86_64 --repoid=base
reposync -p /data/repo/centos/7/x86_64 --repoid=updates
reposync -p /data/repo/centos/7/x86_64 --repoid=extras
reposync -p /data/repo/centos/7/x86_64 --repoid=epel
reposync -p /data/repo/centos/7/x86_64 --repoid=openstack-juno

sed "s/gpgcheck=1/gpgcheck=1\nenabled=0/g" /etc/yum.repos.d/CentOS-Base.repo > /etc/yum.repos.d/CentOS-Base.repo
cp /home/devops/git/juno-saltstack/kickstart/etc/yum.repos.d/local.repo /etc/yum.repos.d/local.repo

yum clean all
yum update

### Setup Apache

yum install -y httpd
systemctl start httpd
systemctl enable httpd
 
### Setup NTPD

systemctl start ntpd
systemctl enable ntpd

ntpq -p

### Setup DHCP Server

yum install -y dhcp

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.`date +%s`
cp /home/devops/git/juno-saltstack/kickstart/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf

systemctl start dhcpd
systemctl enable dhcpd

### Setup Salt Master

yum install salt-master
systemctl restart salt-master
systemctl enable salt-master
