
{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set neutron_pass = salt['pillar.get']('openstack:NEUTRON_PASS') %}
{% set neutron_dbpass = salt['pillar.get']('openstack:NEUTRON_DBPASS') %}

{% set nova_pass = salt['pillar.get']('openstack:NOVA_PASS') %}
{% set metadata_secret = salt['pillar.get']('openstack:METADATA_SECRET') %}

# TODO: figure out a better way to assign the nova_admin_tenant_id
#{% set service_tenant_id = salt['pillar.get']('openstack:service_tenant_id','26be2f327660495a822e3b844cfb21e1') %}

{% set rabbit_pass = salt['pillar.get']('openstack:RABBIT_PASS') %}

neutron_db:
  mysql_database.present:
    - name: neutron
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

neutron_grant_localhost:
  mysql_user.present:
    - name: neutron
    - host: localhost
    - password: {{ neutron_dbpass }}
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
    - database: neutron.*
    - user: neutron
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

neutron_grant_all:
  mysql_user.present:
    - name: neutron 
    - host: '%'
    - password: {{ neutron_dbpass }}
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
    - database: neutron.*
    - user: neutron
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

openstack_neutron:
  pkg.installed:
    - name: openstack-neutron

openstack_neutron_ml2:
  pkg.installed:
    - name: openstack-neutron-ml2

python_neutronclient:
  pkg.installed:
    - name: python-neutronclient

neutron_controller_conf_connection:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: database
    - parameter: connection
    - value: mysql://neutron:{{ neutron_dbpass }}@{{ mysql_host }}/neutron

neutron_controller_conf_rabbit:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: rpc_backend
    - value: rabbit

neutron_controller_conf_rabbit_host:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: rabbit_host
    - value: {{ controller }}

neutron_controller_conf_rabbit_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: rabbit_password
    - value: {{ rabbit_pass }}

neutron_controller_conf_DEFAULT_auth_strategy:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

neutron_controller_conf_auth_uri:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: auth_uri
    - value: http://{{ controller }}:5000/v2.0

neutron_controller_conf_identity_uri:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: identity_uri
    - value: http://{{ controller }}:35357

neutron_controller_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: admin_tenant_name
    - value: service

neutron_controller_conf_admin_user:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: admin_user
    - value: neutron

neutron_controller_conf_admin_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: keystone_authtoken
    - parameter: admin_password
    - value: {{ neutron_pass }}

neutron_controller_conf_core_plugin:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: core_plugin
    - value: ml2

neutron_controller_conf_service_plugins:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: service_plugins
    - value: router

neutron_controller_conf_allow_overlapping_ips:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: allow_overlapping_ips
    - value: 'True'

neutron_controller_conf_nova_admin_auth_url:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_admin_auth_url
    - value: http://{{ controller }}:35357/v2.0

neutron_controller_conf_nova_region_name:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_region_name
    - value: regionOne

neutron_controller_conf_nova_admin_username:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_admin_username
    - value: nova

neutron_controller_conf_nova_admin_tenant_id:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_admin_tenant_id
    - value: {{ service_tenant_id }}

neutron_controller_conf_nova_admin_password:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: nova_admin_password
    - value: {{ nova_pass }}



neutron_controller_conf_type_drivers:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: type_drivers
    - value: 'flat, gre'

neutron_controller_conf_tenant_network_types:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: tenant_network_types 
    - value: gre

neutron_controller_conf_mechanism_drivers:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2
    - parameter: mechanism_drivers 
    - value: openvswitch


neutron_controller_conf_tunnel_id_ranges:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2_type_gre
    - parameter: tunnel_id_ranges
    - value: 1:1000

neutron_controller_conf_enable_security_group:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: enable_security_group
    - value: 'True'

neutron_controller_conf_enable_ipset:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: enable_ipset
    - value: 'True'

neutron_controller_conf_firewall_driver:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: securitygroup
    - parameter: firewall_driver
    - value: neutron.agent.linux.iptables_firewall.OVSHybridIptablesFirewallDriver




nova_controller_conf_network_api_class:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: network_api_class 
    - value: nova.network.neutronv2.api.API

nova_controller_conf_security_group_api:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: security_group_api  
    - value: neutron

nova_controller_conf_linuxnet_interface_driver:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: linuxnet_interface_driver
    - value: nova.network.linux_net.LinuxOVSInterfaceDriver

nova_controller_conf_DEFAULT_firewall_driver:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: firewall_driver
    - value: nova.virt.firewall.NoopFirewallDriver

nova_controller_conf_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: url
    - value: http://{{ controller }}:9696

neutron_controller_conf_auth_strategy:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: auth_strategy
    - value: keystone

nova_controller_conf_admin_auth_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_auth_url
    - value: http://{{ controller }}:35357/v2.0

nova_controller_conf_admin_tenant_name:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_tenant_name
    - value: service

nova_controller_conf_admin_username:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_username
    - value: neutron

nova_controller_conf_admin_password:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: admin_password
    - value: {{ neutron_pass }}

/etc/neutron/plugin.ini:
  file.symlink:
    - name: /etc/neutron/plugin.ini
    - target: /etc/neutron/plugins/ml2/ml2_conf.ini


#### TODO: su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf \
####  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno" neutron


openstack_nova_api_service:
  service.running:
    - name: openstack-nova-api
    - enable: True
    - reload: True

openstack_nova_scheduler_service:
  service.running:
    - name: openstack-nova-scheduler
    - enable: True
    - reload: True
openstack_nova_conductor_service:
  service.running:
    - name: openstack-nova-conductor
    - enable: True
    - reload: True

openstack_neutron_server_running:
  service.running:
    - name: neutron-server
    - enable: True

openstack_neutron_server_enabled_on_boot:
  service.enabled:
    - name: neutron-server

