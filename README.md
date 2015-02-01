### juno-saltstack

See also: https://github.com/dkilcy/saltstack-base

![Node Deployment](node-deployment.jpg "Node Deployment")

Contents:  

- states: SaltStack state files  
- pillar: SaltStack pillar data  
- notes : Documentation and sample configuration files  


### Prepare Salt Master

1. Add the Openstack repository and update.  
(Note: The repo isn't available by rsync, so the local copy is updated using reposync )
```
yum install -y http://rdo.fedorapeople.org/openstack-juno/rdo-release-juno.rpm
yum update -y
yum upgrade -y
```

1. Add to /etc/salt/master.d/99-salt-envs.conf
```
file_roots:
  base:
    - /srv/salt/base/states
  openstack:
    - /srv/salt/openstack/states
 
pillar_roots:
  base:
    - /srv/salt/base/pillar
  openstack:
    - /srv/salt/openstack/pillar
```

2. Point SaltStack to the git repository on the Salt Master

```
ln -sf /home/devops/git/juno-saltstack /srv/salt/openstack
```

Restart Salt Master after adding file.
```
systemctl restart salt-master.service
salt '*' test.ping
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```

Set the grains for each machine
```
salt 'controller*' grains.setvals "{'environment':'openstack', 'role':'controller' }"
salt 'compute*' grains.setvals "{'environment':'openstack', 'role':'compute' }"
salt 'network*' grains.setvals "{'environment':'openstack', 'role':'network' }"
```




