{% set controller = pillar['openstack']['controller'] %}

dir_setup:
  file.directory:
    - name: /home/devops/openstack
    - user: devops
    - group: devops
    - mode: 775

auth_setup:
  file.managed:
    - name: /home/devops/openstack/auth-openrc.sh
    - user: devops
    - group: devops
    - mode: 755 
    - create: True
    - contents: |
        export ADMIN_PASS={{ pillar['openstack']['ADMIN_PASS'] }}
        export ADMIN_TOKEN={{ pillar['openstack']['ADMIN_TOKEN'] }}
        export CEILOMETER_DBPASS={{ pillar['openstack']['CEILOMETER_DBPASS'] }}
        export CEILOMETER_PASS={{ pillar['openstack']['CEILOMETER_PASS'] }}
        export CINDER_DBPASS={{ pillar['openstack']['CINDER_DBPASS'] }}
        export CINDER_PASS={{ pillar['openstack']['CINDER_PASS'] }}
        export DASH_DBPASS={{ pillar['openstack']['DASH_DBPASS'] }}
        export DEMO_PASS={{ pillar['openstack']['DEMO_PASS'] }}
        export GLANCE_DBPASS={{ pillar['openstack']['GLANCE_DBPASS'] }}
        export GLANCE_PASS={{ pillar['openstack']['GLANCE_PASS'] }}
        export HEAT_DBPASS={{ pillar['openstack']['HEAT_DBPASS'] }}
        export HEAT_PASS={{ pillar['openstack']['HEAT_PASS'] }}
        export KEYSTONE_DBPASS={{ pillar['openstack']['KEYSTONE_DBPASS'] }}
        export METADATA_SECRET={{ pillar['openstack']['METADATA_SECRET'] }}
        export NEUTRON_DBPASS={{ pillar['openstack']['NEUTRON_DBPASS'] }}
        export NEUTRON_PASS={{ pillar['openstack']['NEUTRON_PASS'] }}
        export NOVA_DBPASS={{ pillar['openstack']['NOVA_DBPASS'] }}
        export NOVA_PASS={{ pillar['openstack']['NOVA_PASS'] }}
        export RABBIT_PASS={{ pillar['openstack']['RABBIT_PASS'] }}
        export TROVE_DBPASS={{ pillar['openstack']['TROVE_DBPASS'] }}
        export TROVE_PASS={{ pillar['openstack']['TROVE_PASS'] }}
        export SWIFT_PASS={{ pillar['openstack']['SWIFT_PASS'] }}

admin_setup:
  file.managed:
    - name: /home/devops/openstack/admin-openrc.sh
    - user: devops
    - group: devops
    - mode: 755 
    - create: True
    - contents: |
        export OS_USERNAME=admin
        export OS_PASSWORD=$ADMIN_PASS
        export OS_TENANT_NAME=admin
        export OS_AUTH_URL=http://{{ controller }}:35357/v2.0

demo_setup:
  file.managed:
    - name: /home/devops/openstack/demo-openrc.sh
    - user: devops
    - group: devops
    - mode: 755 
    - contents: |
        export OS_USERNAME=demo
        export OS_PASSWORD=$DEMO_PASS
        export OS_TENANT_NAME=demo
        export OS_AUTH_URL=http://{{ controller }}:5000/v2.0


