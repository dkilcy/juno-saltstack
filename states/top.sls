
openstack:

  'G@juno-saltstack':
    - yumrepo

  'G@juno-saltstack:role:controller':
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

#  'G@juno-saltstack:role:network':
#    - openstack.utils
#    - openstack.auth
#    - openstack.neutron.network

  'G@juno-saltstack:role:compute':
    - openstack.utils
    - openstack.auth
    - openstack.nova.compute
    - openstack.neutron.compute
#    - openstack.ceilometer.compute

#  'G@juno-saltstack:role:block':
#    - openstack.utils
#    - openstack.auth
#    - openstack.cinder.storage
#  'G@juno-saltstack:role:object':
#    - openstack.utils
#    - openstack.auth
#    - openstack.swift.storage
