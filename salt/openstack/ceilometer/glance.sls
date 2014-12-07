
{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}

{{ configure_rabbitmq( 'ceilometer_glance', '/etc/glance/glance-api.conf' ) }}

ceilometer_glance_notification_driver:
  openstack_config.present:
    - filename: /etc/glance/glance-api.conf
    - section: DEFAULT
    - parameter: notification_driver
    - value: messaging

openstack_glance_api_service:
  service.running:
    - name: openstack-glance-api
    - reload: True
    - watch.file:
      - name: /etc/glance/glance-api.conf

openstack_glance_registry_service:
  service.running:
    - name: openstack-glance-registry
    - reload: True
    - watch.file:
      - name: /etc/glance/glance-api.conf

