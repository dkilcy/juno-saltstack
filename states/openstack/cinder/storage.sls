{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}

{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set cinder_pass = salt['pillar.get']('openstack:CINDER_PASS') %}
{% set cinder_dbpass = salt['pillar.get']('openstack:CINDER_DBPASS') %}

{% set ip_addr = salt['network.interfaces']()['team0']['inet'][0]['address'] %}


lvm2:
  pkg.installed:
    - name: lvm2

  service.running:
    - name: lvm2-lvmetad
    - enable: True
    - reload: True
 
#lvm.pv_present:
#  - name: /dev/sda1
# 
#lvm.pv_present:
#  - name: /dev/sdb1
 
 
openstack-cinder:
  pkg.installed:
    - name: openstack-cinder

targetcli:
  pkg.installed:
    - name: targetcli

python-oslo-db:
  pkg.installed:
    - name: python-oslo-db

MySQL-python:
  pkg.installed:
    - name: MySQL-python

cinder_conf_connection:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: database
    - parameter: connection
    - value: 'mysql://cinder:{{ cinder_dbpass }}@{{ mysql_host }}/cinder'

{{ configure_rabbitmq( 'cinder_controller', '/etc/cinder/cinder.conf' ) }}

cinder_auth_strategy:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

{{ configure_identity( 'cinder_controller', '/etc/cinder/cinder.conf', 'cinder', cinder_pass ) }}

cinder_conf_my_ip:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: DEFAULT
    - parameter: my_ip
    - value: {{ ip_addr }}

cinder_conf_glance:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: DEFAULT
    - parameter: glance_host
    - value: {{ controller }}

cinder_conf_scsi:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: DEFAULT
    - parameter: iscsi_helper
    - value: lioadm

cinder_conf_verbose:
  openstack_config.present:
    - filename: /etc/cinder/cinder.conf
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'



