# run as root user

setenforce 0

cd /home/devops
git clone https://github.com/dkilcy/juno-saltstack/juno-saltstack.git
chown -R devops.devops /home/devops/git

mv /etc/hosts /etc/hosts.orig
ln -s /home/devops/git/juno-saltstack/kickstart/etc/hosts /etc/hosts

mkdir -p /root/staging/etc/yum.repos.d/
mv /etc/yum.repos.d/* /root/staging/etc/yum.repos.d
ln -s /home/devops/git/juno-saltstack/kickstart/etc/yum.repos.d/local.repo /etc/yum.repos.d/local.repo

### Add EPEL and OpenStack repository

yum install -y yum-plugin-priorities
yum install -y http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y

### Setup security policies

yum install -y openstack-selinux

#setenforce 0
#service iptables stop

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

yum install -y httpd
 
service ntpd start
chkconfig ntpd on

ntpq -p

yum install -y dhcp

mv /etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf.orig
ln -s /home/devops/git/juno-saltstack/kickstart/etc/dhcp/dhcpd.conf /etc/dhcp/dhcpd.conf

service dhcpd restart
