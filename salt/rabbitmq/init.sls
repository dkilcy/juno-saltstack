
rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server

rabbitmq-server-enabled:
  service.enabled:
    - name: rabbitmq-server
    - enabled: True

rabbitmq-server-running:
  service.running:
    - name: rabbitmq-server
    - enable: True

rabbit_user:
    rabbitmq_user.present:
        - password: {{ salt['pillar.get']('openstack:RABBIT_PASS') }}
        - force: True
