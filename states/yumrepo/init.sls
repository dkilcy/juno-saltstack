
openstack-juno.repo:
  file.append:
    - name: /etc/yum.repos.d/local.repo
    - text: |
        [openstack-juno]
        name=OpenStack Juno Repository
        baseurl=http://yumrepo/repo/centos/$releasever/openstack-juno/
        gpgcheck=0
        enabled=1
