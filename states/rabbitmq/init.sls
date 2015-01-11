
rabbitmq-server:
  pkg.installed:
    - name: rabbitmq-server

  service.running:
    - name: rabbitmq-server
    - enable: True
    - reload: True
    - require:
      - pkg: rabbitmq-server

#rabbit_user:
#  rabbitmq_user.present:
#    - password: {{ salt['pillar.get']('openstack:RABBIT_PASS') }}
#    - require:
#      - service: rabbitmq-server
    
