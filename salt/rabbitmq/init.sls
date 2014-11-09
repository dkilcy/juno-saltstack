
rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server

rabbitmq-server-running:
  service.running:
    - name: rabbitmq-server
    - enable: True

rabbit_user:
    rabbitmq_user.present:
        - password: {{ salt['pillar.get']('openstack:RABBIT_PASS') }}
        - force: True
