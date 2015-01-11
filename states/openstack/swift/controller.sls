
openstack-swift-proxy:
  pkg.installed:
    - name: openstack-swift-proxy

python-swiftclient:
  pkg.installed:
    - name: python-swiftclient

python-keystone-auth-token:
  pkg.installed:
    - name: python-keystone-auth-token

python-keystonemiddleware:
  pkg.installed:
    - name: python-keystonemiddleware

memcached:
  pkg.installed:
    - name: memcached

#/etc/swift/proxy-server.conf:
#  cmd.run:
#    - name: curl -o /etc/swift/proxy-server.conf https://raw.githubusercontent.com/openstack/swift/stable/juno/etc/proxy-server.conf-sample


