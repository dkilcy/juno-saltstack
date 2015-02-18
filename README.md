### juno-saltstack

See also: https://github.com/dkilcy/saltstack-base

![Node Deployment](notes/node-deployment.png "Node Deployment")

Install OpenStack in a 3+ node architecture.  Neutron networking.

Contents:  

- states: SaltStack state files  
- pillar: SaltStack pillar data  
- notes : Documentation and sample configuration files  

### Update Salt Master

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

2. Point Salt to the git repository on the Salt Master: `ln -sf /home/devops/git/juno-saltstack /srv/salt/openstack`
3. Restart Salt Master: `systemctl restart salt-master.service`

### Install Nodes (minions)

Install the OS nodes via kickstarter boot with USB.

### Post-Install

From the Salt master:
1. Add the keys from the minions to the master: `salt-key -L`
1. Test the installation: `salt '*' test.ping`
2. Update the minions with the pillar configuration

```
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```

4. Set the grains for each machine

 ```bash
salt 'controller*' grains.setvals "{'environment':'openstack', 'role':'controller' }"
salt 'compute*' grains.setvals "{'environment':'openstack', 'role':'compute' }"
salt 'network*' grains.setvals "{'environment':'openstack', 'role':'network' }"
```




