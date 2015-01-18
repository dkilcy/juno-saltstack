
#### Source the environment
```
source auth-openrc.sh
source admin-openrc.sh
```

#### Create nova user
```
keystone user-create --name nova --pass $NOVA_PASS
keystone user-role-add --user nova --tenant service --role admin
keystone service-create --name nova --type compute --description "OpenStack Compute"
keystone service-list
```

#### Create the endpoint
```
keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ compute / {print $2}') \
  --publicurl http://controller1:8774/v2/%\(tenant_id\)s \
  --internalurl http://controller1:8774/v2/%\(tenant_id\)s \
  --adminurl http://controller1:8774/v2/%\(tenant_id\)s \
  --region regionOne
```
 
```
keystone user-list
keystone role-list
keystone service-list
keystone endpoint-list
```
