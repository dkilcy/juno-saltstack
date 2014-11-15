
unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
source auth-openrc.sh
source admin-openrc.sh

keystone user-create --name glance --pass $GLANCE_PASS
sleep 1
keystone user-role-add --user glance --tenant service --role admin
sleep 1


keystone service-create --name glance --type image --description "OpenStack Image Service"
sleep 1
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ image / {print $2}') \
  --publicurl http://controller1:9292 \
  --internalurl http://controller1:9292 \
  --adminurl http://controller1:9292 \
  --region regionOne
sleep 1

keystone tenant-list
keystone user-list
keystone role-list
keystone endpoint-list

# systemctl enable openstack-glance-api.service openstack-glance-registry.service
# systemctl start openstack-glance-api.service openstack-glance-registry.service

# wget http://cdn.download.cirros-cloud.net/0.3.3/cirros-0.3.3-x86_64-disk.img

glance image-create --name "cirros-0.3.3-x86_64" --file cirros-0.3.3-x86_64-disk.img \
  --disk-format qcow2 --container-format bare --is-public True --progress

sleep 1
glance image-list


