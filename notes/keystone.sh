
source /home/devops/openstack/auth-openrc.sh

export OS_SERVICE_TOKEN=$ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://controller1:35357/v2.0

keystone tenant-create --name admin --description "Admin Tenant"
keystone user-create --name admin --pass $ADMIN_PASS
keystone role-create --name admin
keystone user-role-add --tenant admin --user admin --role admin
keystone role-create --name _member_
keystone user-role-add --tenant admin --user admin --role _member_
keystone tenant-create --name demo --description "Demo Tenant"
keystone user-create --name demo --pass $DEMO_PASS
keystone user-role-add --tenant demo --user demo --role _member_
keystone tenant-create --name service --description "Service Tenant"

sleep 1

keystone service-create --name keystone --type identity \
  --description "OpenStack Identity"

sleep 1

keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ identity / {print $2}') \
  --publicurl http://controller1:5000/v2.0 \
  --internalurl http://controller1:5000/v2.0 \
  --adminurl http://controller1:35357/v2.0 \
  --region regionOne

sleep 1

unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
source admin-openrc.sh 
keystone tenant-list
keystone user-list
keystone role-list
keystone endpoint-list

