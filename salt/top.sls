
base:
  '*':
    - vim
    - users

  'controller*':
    - openstack.ipv4
#    - openstack.ipv4.controller
    - ntp
    - openstack.utils
    - openstack.auth
    - mariadb
#    - rabbitmq
#    - openstack.keystone
#    - openstack.glance
#    - openstack.nova_controller
#    - openstack.neutron_controller
#    - openstack.horizon
#    - openstack.ceilometer_controller
#    - openstack.ceilometer_glance

  'network*':
    - openstack.ipv4
#    - openstack.ipv4.network
    - ntp
    - openstack.utils
    - openstack.auth
#    - openstack.neutron_network
    
  'compute*':
    - openstack.ipv4
#    - openstack.ipv4.compute
    - ntp
    - openstack.utils
    - openstack.auth
#    - openstack.nova_compute
#    - openstack.neutron_compute
#    - openstack.ceilometer_compute

  'block*':
    - openstack.ipv4
#    - openstack.ipv4.block
    - ntp

  'object*':
    - openstack.ipv4
#    - openstack.ipv4.object
    - ntp

