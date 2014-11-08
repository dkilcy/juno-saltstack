
{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}

{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}

{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set nova_dbpass = salt['pillar.get']('openstack:NOVA_DBPASS') %}
{% set nova_pass = salt['pillar.get']('openstack:NOVA_PASS') %}

{% set ip_addr = salt['network.interfaces']()['team0']['inet'][0]['address'] %}

{% set rabbit_pass = salt['pillar.get']('openstack:RABBIT_PASS') %}

openstack_nova_compute:
  pkg.installed:
    - name: openstack-nova-compute

sysfsutils:
  pkg.installed:
    - name: sysfsutils

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

nova_conf_rabbit_password:
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

nova_conf_vnc_enabled:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vnc_enabled
    - value: 'True'

nova_conf_vncserver_listen:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_listen
    - value: 0.0.0.0

nova_conf_vncserver_proxyclient_address:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: vncserver_proxyclient_address
    - value: {{ ip_addr }}

nova_conf_novncproxy_base_url:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: novncproxy_base_url
    - value: http://{{ controller }}:6080/vnc_auto.html

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


nova_libvirtd_service:
  service.running:
    - name: libvirtd
    - enable: True

nova_compute_service:
  service.running:
    - name: openstack-nova-compute
    - enable: True

nova_libvirtd_enabled_on_boot:
  service.enabled:
    - name: libvirtd

nova_compute_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-compute

