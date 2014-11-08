
{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set nova_dbpass = salt['pillar.get']('openstack:NOVA_DBPASS') %}
{% set nova_pass = salt['pillar.get']('openstack:NOVA_PASS') %}

{% set ip_addr = salt['network.interfaces']()['team0']['inet'][0]['address'] %}

{% set rabbit_pass = salt['pillar.get']('openstack:RABBIT_PASS') %}

nova_db:
  mysql_database.present:
    - name: nova
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

nova_grant_localhost:
  mysql_user.present:
    - name: nova
    - host: localhost
    - password: {{ nova_dbpass }}
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
    - database: nova.*
    - user: nova
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

nova_grant_all:
  mysql_user.present:
    - name: nova
    - host: '%'
    - password: {{ nova_dbpass }}
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
    - database: nova.*
    - user: nova
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

### TODO: put back in service credentials


openstack_nova_api:
  pkg.installed:
    - name: openstack-nova-api

openstck_nova_cert:
  pkg.installed:
    - name: openstack-nova-cert

openstack_nova_conductor:
  pkg.installed:
    - name: openstack-nova-conductor

openstack_nova_console:
  pkg.installed:
    - name: openstack-nova-console

openstack_nova_novncproxy:
  pkg.installed:
    - name: openstack-nova-novncproxy

openstack_nova_scheduler:
  pkg.installed:
    - name: openstack-nova-scheduler

python_novaclient:
  pkg.installed:
    - name: python-novaclient

# TODO: add missing [database] section to /etc/nova/nova.conf

nova_conf_connection:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: database
    - parameter: connection
    - value: 'mysql://nova:{{ nova_dbpass }}@{{ mysql_host }}/nova'

nova_conf_rabbit:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: rpc_backend
    - value: rabbit

nova_conf_rabbit_host:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: rabbit_host
    - value: {{ controller }}

nova_conf_rabit_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: rabbit_password
    - value: {{ rabbit_pass }}


nova_conf_auth_strategy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

nova_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://{{ controller }}:5000/v2.0

nova_conf_identity_uri:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: identity_uri
    - value: http://{{ controller }}:35357

nova_conf_admin_user:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: admin_user
    - value: nova

nova_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: admin_tenant_name
    - value: service

nova_conf_admin_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: keystone_authtoken
    - parameter: admin_password
    - value: {{ nova_pass }}

nova_conf_my_ip:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: my_ip
    - value: {{ ip_addr }} 

nova_conf_vncserver_listen:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_listen
    - value: {{ ip_addr }} 

nova_conf_vncserver_proxyclient_address:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_proxyclient_address
    - value: {{ ip_addr }}

nova_conf_controller:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: glance
    - parameter: host
    - value: {{ controller }}

nova_conf_verbose:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'

nova_db_sync:
  cmd.run:
    - name: nova-manage db sync

nova_api_service:
  service.running:
    - name: openstack-nova-api
    - enable: True

nova_cert_service:
  service.running:
    - name: openstack-nova-cert
    - enable: True

nova_consoleauth_service:
  service.running:
    - name: openstack-nova-consoleauth
    - enable: True

nova_scheduler_service:
  service.running:
    - name: openstack-nova-scheduler
    - enable: True

nova_conductor_service:
  service.running:
    - name: openstack-nova-conductor
    - enable: True

nova_novncproxy_service:
  service.running:
    - name: openstack-nova-novncproxy
    - enable: True

nova_api_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-api

nova_cert_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-cert

nova_consoleauth_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-consoleauth

nova_scheduler_on_boot:
  service.enabled:
    - name: openstack-nova-scheduler

nova_conductor_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-conductor

nova_novncproxy_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-novncproxy



