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

openstack_nova_compute:
  pkg.installed:
    - name: openstack-nova-compute

sysfsutils:
  pkg.installed:
    - name: sysfsutils

#################################################################
{{ configure_rabbitmq( 'nova_compute', '/etc/nova/nova.conf' ) }}
{{ configure_identity( 'nova_compute', '/etc/nova/nova.conf', 'nova', nova_pass ) }}

nova_compute_conf_auth_strategy:
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

