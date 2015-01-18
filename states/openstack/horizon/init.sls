
{% set controller = salt['pillar.get']('openstack:controller') %}

openstack-dashboard:
  pkg.installed:
    - pkgs:
      - openstack-dashboard
      - httpd
      - mod_wsgi
      - memcached
      - python-memcached

openstack-dashboard-css:
  cmd.run:
    - name: chown -R apache:apache /usr/share/openstack-dashboard/static
    - require:
      - pkg: openstack-dashboard

openstack-dashboard-allowed_hosts:
  file.replace:
    - name: /etc/openstack-dashboard/local_settings
    - pattern: ALLOWED_HOSTS = \['horizon.example.com', 'localhost'\]
    - repl: ALLOWED_HOSTS = ['*']

openstack-dashboard-controller:
  file.replace:
    - name: /etc/openstack-dashboard/local_settings
    - pattern: OPENSTACK_HOST = "127.0.0.1"
    - repl: OPENSTACK_HOST = "{{ controller }}"

httpd:
  service.running:
    - name: httpd
    - enable: True

#  service.running:
#    - name: memcached
#    - enable: True
#    - require:
#      - service: httpd

