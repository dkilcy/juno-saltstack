
{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set glance_pass = salt['pillar.get']('openstack:GLANCE_PASS') %}
{% set glance_dbpass = salt['pillar.get']('openstack:GLANCE_DBPASS') %}

glance_db:
  mysql_database.present:
    - name: glance
    - host: {{ mysql_host }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
      - pkg: {{ mysql.python }}
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}

glance_grant_localhost:
  mysql_user.present:
    - name: glance
    - host: localhost
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
      - pkg: {{ mysql.python }}
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: localhost
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
      - pkg: {{ mysql.python }}
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}

glance_grant_all:
  mysql_user.present:
    - name: glance 
    - host: '%'
    - password: {{ glance_dbpass }}
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
      - pkg: {{ mysql.python }}
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}

  mysql_grants.present:
    - grant: all privileges
    - database: glance.*
    - user: glance
    - host: '%'
    - connection_user: root
    - connection_pass: '{{ mysql_root_password }}'
    - connection_charset: utf8
    - require:
      - service: {{ mysql.service }}
      - pkg: {{ mysql.python }}
      {%- if mysql_root_password %}
      - cmd: mysql_root_password
      {%- endif %}

## TODO: put back in keystone states when fix is avail for Centos 7

openstack_glance:
  pkg.installed:
    - name: openstack-glance

python_glanceclient:
  pkg.installed:
    - name: python-glanceclient

glance_conf_1:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: database
    - parameter: connection
    - value: 'mysql://glance:{{ glance_dbpass }}@{{ mysql_host }}/glance'      

glance_api_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://{{ controller }}:5000/v2.0

glance_api_conf_identity_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: identity_uri
    - value: http://{{ controller }}:35357

glance_api_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: admin_tenant_name
    - value: service

glance_api_conf_admin_user:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: admin_user
    - value: glance

glance_api_conf_admin_password:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: keystone_authtoken
    - parameter: admin_password
    - value: {{ glance_pass }}

glance_api_conf_flavor:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: paste_deploy
    - parameter: flavor
    - value: keystone

glance_api_conf_default_store:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: glance_store
    - parameter: default_store
    - value: file

glance_api_conf_datadir:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: glance_store
    - parameter: filesystem_store_datadir
    - value: /var/lib/glance/images/

glance_api_conf_verbose:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'



glance_registry_connection:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: database
    - parameter: connection
    - value: 'mysql://glance:{{ glance_dbpass }}@{{ mysql_host }}/glance'     

glance_registry_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://{{ controller }}:5000/v2.0

glance_registry_conf_identity_uri:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: identity_uri
    - value: http://{{ controller }}:35357

glance_api_registry_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: admin_tenant_name
    - value: service

glance_api_registry_admin_user:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: admin_user
    - value: glance

glance_api_registry_admin_password:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: keystone_authtoken
    - parameter: admin_password
    - value: {{ glance_pass }}

glance_api_registry_flavor:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: paste_deploy
    - parameter: flavor
    - value: keystone

glance_api_registry_verbose:
  openstack_config.present:
    - filename: /etc/glance/glance-registry.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

glance_db_sync:
  cmd.run:
    - name: glance-manage db_sync

## need below since cmd.run as root and clobbers the api log file permission

/var/log/glance:
  file.directory:
    - user: glance 
    - group: glance 
    - mode: 750
    - create: True

/var/log/glance/api.log:
  file.managed:
    - user: glance
    - group: glance
    - mode: '644'
    - create: True

/var/log/glance/registry.log:
  file.managed:
    - user: glance
    - group: glance
    - mode: '644'
    - create: True

glance_api_enabled_on_boot:
  service.enabled:
    - name: openstack-glance-api

glance_registry_enabled_on_boot:
  service.enabled:
    - name: openstack-glance-registry

glance_api_service:
  service.running:
    - name: openstack-glance-api
    - enable: True

glance_registry_service:
  service.running:
    - name: openstack-glance-registry
    - enable: True



