
base:
  '*':
    - vim

#  'workstation*':
#    - openstack.auth

  'controller*':
    - users
    - openstack.ipv4.controller
    - ntp
    - openstack.utils
    - openstack.auth
#    - rabbitmq
#    - openstack.keystone
#    - openstack.glance
#    - openstack.nova_controller
#    - openstack.neutron_controller
#    - openstack.horizon
#    - openstack.ceilometer_controller
#    - openstack.ceilometer_glance

  'network*':
    - users
    - openstack.ipv4.network
    - ntp
    - openstack.utils
    - openstack.auth
#    - openstack.neutron_network
    
  'compute*':
    - users
    - openstack.ipv4.compute
    - ntp
    - openstack.utils
    - openstack.auth
#    - openstack.nova_compute
#    - openstack.neutron_compute
#    - openstack.ceilometer_compute

#  'block*':
#    - users
#    - openstack.ipv4.block
#    - ntp

#  'object*':
#    - users
#    - openstack.ipv4.object
#    - ntp

