
### demo-tenant.md

#### Source the environment
```
source auth-openrc.sh 
source demo-openrc.sh 
```

#### Add keypair
```
nova keypair-add --pub-key ~/.ssh/id_rsa.pub demo-key
nova keypair-list
```

####
```
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

nova secgroup-list
```

#### Create VM
```
nova boot \
  --flavor m1.tiny \
  --image cirros-0.3.3-x86_64 \
  --nic net-id=66456847-e3f2-47d1-9452-0f133894de50 \
  --security-group default \
  --key-name demo-key demo-instance1
  
nova list
```

#### Create floating IP
```
neutron floatingip-create ext-net
```

#### Associate floating IP with VM
```
nova floating-ip-associate demo-instance1 192.168.1.201
ping 192.168.1.201
```

#### References

[Launch an instance with OpenStack Networking (neutron)][1]

[1]: http://docs.openstack.org/juno/install-guide/install/yum/content/launch-instance-neutron.html
