# http://docs.openstack.org/juno/install-guide/install/yum/content/keystone-install.html

{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}

{% set admin_pass = salt['pillar.get']('openstack:ADMIN_PASS') %}
{% set demo_pass = salt['pillar.get']('openstack:DEMO_PASS') %}

### To finalize installation

# http://docs.openstack.org/juno/install-guide/install/yum/content/keystone-users.html

keystone_tenants:
  keystone.tenant_present:
    - names:
      - admin
      - demo
      - service
    - connection_token: {{ admin_token }}

keystone_roles:
  keystone.role_present:
    - names:
      - admin
      - _member_
    - connection_token: {{ admin_token }}

keystone_admin:
  keystone.user_present:
    - name: admin
    - password: {{ admin_pass }}
    - email: devops@workstation-02.mgmt
    - roles:
      - admin:   # tenants
        - admin  # roles
      - service:
        - admin
        - _member_
      - require:
        - keystone: keystone_tenants
        - keystone: keystone_roles
    - connection_token: {{ admin_token }}

keystone_demo:
  keystone.user_present:
    - name: demo
    - password: {{ demo_pass }}
    - email: devops@workstation-02.mgmt
    - roles:
      - demo:
        - _member_
      - require:
        - keystone: keystone_tenants
        - keystone: keystone_roles
    - connection_token: {{ admin_token }}

## http://docs.openstack.org/juno/install-guide/install/yum/content/keystone-services.html

keystone_identity_service:
  keystone.service_present:
    - name: keystone
    - service_type: identity
    - description: 'Service Tenant'
    - connection_token: {{ admin_token }}

keystone_api_endpoint:
  keystone.endpoint_present:
    - name: keystone
    - publicurl: 'http://{{ controller }}:5000/v2.0'
    - internalurl: 'http://{{ controller }}:5000/v2.0'
    - adminurl: 'http://{{ controller }}:35357/v2.0'
    - region: regionOne
    - connection_token: {{ admin_token }}

