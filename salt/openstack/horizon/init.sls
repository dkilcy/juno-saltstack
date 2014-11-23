
openstack-dashboard:
  pkg.installed:
    - name: openstack-dashboard

httpd:
  pkg.installed:
    - name: httpd

mod_wsgi:
  pkg.installed:
    - name: mod_wsgi

memcached:
  pkg.installed:
    - name: memcached

python-memcached:
  pkg.installed:
    - name: python-memcached

openstack-dashboard:
  cmd.run:
    - name: chown -R apache:apache /usr/share/openstack-dashboard/static

#  service.running:
#    - name: httpd
#    - enable: True
#
#  service.running:
#    - name: memcached
#    - enable: True
