### juno-saltstack

See also: https://github.com/dkilcy/saltstack-base

![Node Deployment](notes/node-deployment.png "Node Deployment")

Contents:  

- states: SaltStack state files  
- pillar: SaltStack pillar data  
- notes : Documentation and sample configuration files  

### Prepare Salt Master

1. Add to /etc/salt/master.d/99-salt-envs.conf

 ```yaml
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

 ```bash
ln -sf /home/devops/git/juno-saltstack /srv/salt/openstack
```

3. Restart Salt Master and refresh minions after pointing to repository.

 ```bash
systemctl restart salt-master.service
salt '*' test.ping
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```

4. Set the grains for each machine

 ```bash
salt 'controller*' grains.setvals "{'environment':'openstack', 'role':'controller' }"
salt 'compute*' grains.setvals "{'environment':'openstack', 'role':'compute' }"
salt 'network*' grains.setvals "{'environment':'openstack', 'role':'network' }"
```




