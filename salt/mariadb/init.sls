
mariadb:
  pkg.installed:
    - name: mariadb

mariadb-server:
  pkg.installed:
    - name: mariadb-server

MySQL-python:
  pkg.installed:
    - name: MySQL-python

mariadb_service:
  service.enabled:
    - name: mariadb
    - enable: True

mariadb_service_running:
  service.running:
    - name: mariadb
    - enable: True

/etc/my.cnf.d/juno-saltstack.cnf:
  file.managed:
    - source: salt://mariadb/files/juno-saltstack.cnf
    - mode: 644
    - user: root
    - group: root

{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}
     
mysql_root_password:
  cmd.run:
    - name: mysqladmin --user root password '{{ mysql_root_password|replace("'", "'\"'\"'") }}'
    - unless: mysql --user root --password='{{ mysql_root_password|replace("'", "'\"'\"'") }}' --execute="SELECT 1;"
    - require:
      - service: mariadb_service_running

