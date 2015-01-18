
#### Notes

```
source auth-openrc.sh
source admin-openrc.sh

keystone user-create --name swift --pass $SWIFT_PASS
keystone user-role-add --user swift --tenant service --role admin

keystone service-create --name swift --type object-store \
  --description "OpenStack Object Storage"

keystone endpoint-create \
  --service-id $(keystone service-list | awk '/ object-store / {print $2}') \
  --publicurl 'http://controller1:8080/v1/AUTH_%(tenant_id)s' \
  --internalurl 'http://controller1:8080/v1/AUTH_%(tenant_id)s' \
  --adminurl http://controller1:8080 \
  --region regionOne

exit

swift-ring-builder account.builder create 7 1 1
swift-ring-builder account.builder add r1z1-10.0.0.51:6002/sda1 100
swift-ring-builder account.builder add r1z1-10.0.0.51:6002/sdb1 100
swift-ring-builder account.builder
swift-ring-builder account.builder rebalance

swift-ring-builder container.builder create 7 1 1 
swift-ring-builder container.builder add r1z1-10.0.0.51:6001/sda1 100
swift-ring-builder container.builder add r1z1-10.0.0.51:6001/sdb1 100
swift-ring-builder container.builder 
swift-ring-builder container.builder rebalance

swift-ring-builder object.builder create 7 1 1
swift-ring-builder object.builder add r1z1-10.0.0.51:6000/sda1 100
swift-ring-builder object.builder add r1z1-10.0.0.51:6000/sdb1 100
swift-ring-builder object.builder 
swift-ring-builder object.builder rebalance
```
`
