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

cinder_db:
  mysql_database.present:
    - name: cinder
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

cinder_grant_localhost:
  mysql_user.present:
    - name: cinder
    - host: localhost
    - password: {{ cinder_dbpass }}
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
    - database: cinder.*
    - user: cinder
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

cinder_grant_all:
  mysql_user.present:
    - name: cinder 
    - host: '%'
    - password: {{ cinder_dbpass }}
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
    - database: cinder.*
    - user: cinder
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

openstack-cinder:
  pkg.installed:
    - name: openstack-cinder

python-cinderclient:
  pkg.installed:
    - name: python-cinderclient

python-oslo-db:
  pkg.installed:
    - name: python-oslo-db

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

cinder_db_sync:
  cmd.run:
    - name: cinder-manage db sync
    - user: cinder
    - group: cinder


