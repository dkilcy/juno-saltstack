
base:

  'controller*':
    - openstack.utils
    - openstack.auth
    - mariadb
    - rabbitmq
#    - openstack.keystone
#    - openstack.glance
#    - openstack.nova.controller
#    - openstack.neutron.controller
#    - openstack.horizon
    - openstack.cinder.controller
#    - openstack.ceilometer.controller
#    - openstack.ceilometer.glance

  'network*':
    - openstack.utils
    - openstack.auth
#    - openstack.neutron.network
    
  'compute*':
    - openstack.utils
    - openstack.auth
#    - openstack.nova.compute
#    - openstack.neutron.compute
#    - openstack.ceilometer.compute

  'block*':
    - openstack.utils
    - openstack.auth
    - openstack.cinder.storage

  'object*':
    - openstack.utils
    - openstack.auth

