###
# Install the Telemetry module
# Juno
###

{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}

{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}

{% set ceilometer_pass = salt['pillar.get']('openstack:CEILOMETER_PASS') %}
{% set ceilometer_dbpass = salt['pillar.get']('openstack:CEILOMETER_DBPASS') %}
{% set ceilometer_token = salt['pillar.get']('openstack:CEILOMETER_PASS') %}

{% set mongodb_host = salt['pillar.get']('openstack:controller') %}

###

openstack_ceilometer_api:
  pkg.installed:
    - name: openstack-ceilometer-api

openstack_ceilometer_collector:
  pkg.installed:
    - name: openstack-ceilometer-collector

openstack_ceilometer_notification:
  pkg.installed:
    - name: openstack-ceilometer-notification

openstack_ceilometer_central:
  pkg.installed:
    - name: openstack-ceilometer-central

openstack_ceilometer_alarm:
  pkg.installed:
    - name: openstack-ceilometer-alarm

python_ceilometerclient:
  pkg.installed:
    - name: python-ceilometerclient

###
# 5. Create the database and a ceilometer database user:
###

mongodb_user_create:
  cmd.run:
    - name: "mongo --host {{ controller }} --eval 'db = db.getSiblingDB(\"ceilometer\"); db.addUser({user: \"ceilometer\", pwd: \"{{ ceilometer_dbpass }}\", roles: [ \"readWrite\", \"dbAdmin\" ]})'"

#mongodb_user_create:
#  mongodb_user.present:
#    - name: ceilometer
#    - passwd: {{ ceilometer_dbpass }}
#    - host: {{ controller }}
#    - port: 27017
#    - database: ceilometer

###

ceilometer_mongodb_service:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: database
    - parameter: connection
    - value: 'mongodb://ceilometer:{{ ceilometer_dbpass }}@{{ mongodb_host }}:27017/ceilometer'

###

ceilometer_mongodb_token:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: publisher
    - parameter: metering_secret
    - value: '{{ ceilometer_token }}'

###

#################################################################
{{ configure_rabbitmq( 'ceilometer_controller', '/etc/ceilometer/ceilometer.conf' ) }}
{{ configure_identity( 'ceilometer_controller', '/etc/ceilometer/ceilometer.conf', 'ceilometer', ceilometer_pass ) }}
#################################################################

###

keystone_ceilometer_auth:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone


ceilometer_controller_conf_7:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: service_credentials
    - parameter: os_auth_url
    - value: http://{{ controller }}:5000/v2.0

ceilometer_controller_conf_8:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: service_credentials
    - parameter: os_username
    - value: ceilometer

ceilometer_controller_conf_9:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: service_credentials
    - parameter: os_tenant_name
    - value: service

ceilometer_controller_conf_10:
  openstack_config.present:
    - filename: /etc/ceilometer/ceilometer.conf
    - section: service_credentials
    - parameter: os_password
    - value: {{ ceilometer_pass }}

###
# 9. Create a ceilometer user that the Telemetry service uses to authenticate with the Identity Service.
#    Use the service tenant and give the user the admin role:
###

keystone_ceilometer_user:
  keystone.user_present:
    - name: ceilometer
    - password: {{ ceilometer_pass }}
    - email: devops@workstation-02.mgmt
    - roles:
      - service:  # tenant
        - admin   # role
    - connection_token: {{ admin_token }}
  
###
# 12. Register the Telemetry service with the Identity Service so that other OpenStack services can locate it.
###

ceilometer_identity_service:
  keystone.service_present:
    - name: ceilometer
    - service_type: metering
    - description: 'OpenStack Telemetry'
    - connection_token: {{ admin_token }}

ceilometer_api_endpoint:
  keystone.endpoint_present:
    - name: ceilometer
    - publicurl: http://{{ controller }}:8777
    - internalurl: http://{{ controller }}:8777
    - adminurl: http://{{ controller }}:8777
    - region: regionOne
    - connection_token: {{ admin_token }}

###
# 13. Start the openstack-ceilometer-api, openstack-ceilometer-central, openstack-ceilometer-collector and
#     services and configure them to start when the system boots:
###

openstack_ceilometer_api_service:
  service.running:
    - name: openstack-ceilometer-api
    - enable: True

openstack_ceilometer_collector_service:
  service.running:
    - name: openstack-ceilometer-collector
    - enable: True

openstack_ceilometer_notification_service:
  service.running:
    - name: openstack-ceilometer-notification
    - enable: True

openstack_ceilometer_central_service:
  service.running:
    - name: openstack-ceilometer-central
    - enable: True

openstack_ceilometer_alarm_evaluator_service:
  service.running:
    - name: openstack-ceilometer-alarm-evaluator
    - enable: True

openstack_ceilometer_alarm_notifier_service:
  service.running:
    - name: openstack-ceilometer-alarm-notifier
    - enable: True

