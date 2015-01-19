
openstack:

  'G@environment:openstack':
    - yumrepo

  'G@environment:openstack and G@role:controller':
#    - openstack.utils
#    - openstack.auth
#    - mariadb
#    - rabbitmq
#    - openstack.keystone
#    - openstack.keystone.env
#    - openstack.glance
#    - openstack.nova.controller
#    - openstack.neutron.controller
    - openstack.horizon
#    - openstack.cinder.controller
#    - openstack.swift.controller
#    - mongodb
#    - openstack.ceilometer.controller
#    - openstack.ceilometer.glance

#  'G@environment:openstack and G@role:network':
#    - openstack.utils
#    - openstack.auth
#    - openstack.neutron.network

  'G@environment:openstack and G@role:compute':
    - openstack.utils
    - openstack.auth
#    - openstack.nova.compute
#    - openstack.neutron.compute
#    - openstack.ceilometer.compute

#  'block*':
#    - openstack.utils
#    - openstack.auth
#    - openstack.cinder.storage
#  'object*':
#    - openstack.utils
#    - openstack.auth
#    - openstack.swift.storage
