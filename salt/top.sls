
base:
  '*':
    - users

  'controller*':
    - ntp
#    - openstack.ipv4
#    - openstack.ipv4.controller
    - openstack.utils
    - openstack.auth
    - mariadb
    - rabbitmq
#    - openstack.keystone
#    - openstack.glance
#    - openstack.nova.controller
    - openstack.neutron.controller
#    - openstack.horizon
#    - openstack.ceilometer.controller
#    - openstack.ceilometer.glance

  'network*':
    - ntp
#    - openstack.ipv4
#    - openstack.ipv4.network
    - openstack.utils
    - openstack.auth
#    - openstack.neutron.network
    
  'compute1':
    - ntp
#    - openstack.ipv4
#    - openstack.ipv4.compute
    - openstack.utils
    - openstack.auth
    - openstack.nova.compute
#    - openstack.neutron.compute
#    - openstack.ceilometer.compute

  'block*':
#    - openstack.ipv4
#    - openstack.ipv4.block
    - ntp

  'object*':
#    - openstack.ipv4
#    - openstack.ipv4.object
    - ntp

