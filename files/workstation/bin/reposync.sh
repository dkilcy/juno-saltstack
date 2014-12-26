
##exit

#mkdir -p /data/repo/centos/6/os
#mkdir -p /data/repo/centos/6/updates
#mkdir -p /data/repo/centos/6/extras

cd /data/repo/centos/6

rsync -avrt rsync://mirror.umd.edu/centos/6/os .
rsync -avrt rsync://mirror.umd.edu/centos/6/updates .
rsync -avrt rsync://mirror.umd.edu/centos/6/extras .

#mkdir -p /data/repo/centos/7/os
#mkdir -p /data/repo/centos/7/updates
#mkdir -p /data/repo/centos/7/extras
#mkdir -p /data/repo/centos/7/epel
#mkdir -p /data/repo/centos/7/openstack-juno


cd /data/repo/centos/7

rsync -avrt rsync://mirror.umd.edu/centos/7/os .
rsync -avrt rsync://mirror.umd.edu/centos/7/updates .
rsync -avrt rsync://mirror.umd.edu/centos/7/extras .

reposync -p /data/repo/centos/7 --repoid=epel
reposync -p /data/repo/centos/7 --repoid=openstack-juno

createrepo /data/repo/centos/7/epel
createrepo /data/repo/centos/7/openstack-juno

