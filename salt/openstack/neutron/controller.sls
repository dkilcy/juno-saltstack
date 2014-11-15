{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}
{% from "openstack/neutron/compute_common.jinja" import configure_compute_common with context %}
{% from "openstack/neutron/networking_common.jinja" import configure_networking_common with context  %}

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
{% set service_tenant_id = salt['pillar.get']('openstack:service_tenant_id') %}

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



#
#neutron_user:
#  keystone.user_present:
#    - name: neutron
#    - password: {{ neutron_pass }}
#    - email: devops@workstation-02.mgmt
#    - roles:
#      - service:  # tenant
#        - admin   # role
#    - connection_token: {{ admin_token }}
#
#neutron_network_service:
#  keystone.service_present:
#    - name: neutron
#    - service_type: network
#    - description: 'OpenStack Networking'
#    - connection_token: {{ admin_token }}
#
#neutron_api_endpoint:
#  keystone.endpoint_present:
#    - name: neutron
#    - publicurl: http://{{ controller }}:9696
#    - internalurl: http://{{ controller }}:9696
#    - adminurl: http://{{ controller }}:9696
#    - region: regionOne
#    - connection_token: {{ admin_token }}
#



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

#############################################################################
{{ configure_rabbitmq( 'neutron_controller', '/etc/neutron/neutron.conf' ) }}
{{ configure_identity( 'neutron_controller', '/etc/neutron/neutron.conf', 'neutron', neutron_pass) }}
{{ configure_networking_common( 'controller' ) }}
#################################################

neutron_controller_auth_strategy:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

## e. In the [DEFAULT] section, configure Networking to notify Compute of network topology changes:

neutron_controller_conf_notify_nova_on_port_status_changes:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: notify_nova_on_port_status_changes
    - value: 'True'

neutron_controller_conf_notify_nova_on_port_data_changes:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: notify_nova_on_port_data_changes
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


## To configure Compute to use Networking
##
## By default, distribution packages configure Compute to use legacy networking. You must reconfigure Compute to manage networks through Networking.
##
##  Edit the /etc/nova/nova.conf file and complete the following actions:
#
## a. In the [DEFAULT] section, configure the APIs and drivers:
##

##############################################
{{ configure_compute_common( 'controller' ) }}
##############################################


##  2. Populate the database:
#
#neutron_database:
#  cmd.run:
#    - name: "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade juno"
#    - user: neutron
#    - group: neutron

## 3. Restart the Compute services:

#
#openstack_nova_api_service:
#  service.running:
#    - name: openstack-nova-api
#    - enable: True
#    - reload: True
#
#
#openstack_nova_scheduler_service:
  #service.running:
    #- name: openstack-nova-scheduler
    #- enable: True
    #- reload: True
#
#openstack_nova_conductor_service:
  #service.running:
    #- name: openstack-nova-conductor
    #- enable: True
    #- reload: True
#
### 4. Start the Networking service and configure it to start when the system boots:
#
#openstack_neutron_server_running:
  #service.running:
    #- name: neutron-server
    #- enable: True
#

# On the controller node, edit the /etc/nova/nova.conf file and complete the following action:

neutron_controller_conf_1:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: service_metadata_proxy
    - value: 'True'

neutron_controller_conf_2:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: neutron
    - parameter: metadata_proxy_shared_secret
    - value: {{ metadata_secret }}


