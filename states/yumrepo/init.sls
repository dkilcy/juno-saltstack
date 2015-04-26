
openstack-juno.repo:
  file.managed:
    - name: /etc/yum.repos.d/openstack-juno.repo
    - source: salt://yumrepo/files/openstack-juno.repo

