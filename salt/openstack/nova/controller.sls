{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}

{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set nova_dbpass = salt['pillar.get']('openstack:NOVA_DBPASS') %}
{% set nova_pass = salt['pillar.get']('openstack:NOVA_PASS') %}

{% set ip_addr = salt['network.interfaces']()['team0']['inet'][0]['address'] %}


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


nova_user:
  keystone.user_present:
    - name: nova
    - password: {{ nova_pass }}
    - email: devops@workstation-02.mgmt
    - roles:
      - service:  # tenant
        - admin   # role
    - connection_token: {{ admin_token }}

nova_identity_service:
  keystone.service_present:
    - name: nova
    - service_type: compute
    - description: 'OpenStack Compute'
    - connection_token: {{ admin_token }}

nova_api_endpoint:
  keystone.endpoint_present:
    - name: nova
    - publicurl: 'http://{{ controller }}:8774/v2/%(tenant_id)s'
    - internalurl: 'http://{{ controller }}:8774/v2/%(tenant_id)s'
    - adminurl: 'http://{{ controller }}:8774/v2/%(tenant_id)s'
    - region: regionOne
    - connection_token: {{ admin_token }}


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


nova_conf_add_database_section:
  file.append:
    - name: /etc/nova/nova.conf
    - text: '[database]'

nova_conf_connection:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: database
    - parameter: connection
    - value: 'mysql://nova:{{ nova_dbpass }}@{{ mysql_host }}/nova'

#################################################################
{{ configure_rabbitmq( 'nova_controller', '/etc/nova/nova.conf' ) }}
{{ configure_identity( 'nova_controller', '/etc/nova/nova.conf', 'nova', nova_pass ) }}
#################################################################

nova_controller_auth_strategy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

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
    - user: nova
    - group: nova

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


