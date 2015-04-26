### Salt tools for OpenStack Juno

Dependencies: [dkilcy/saltstack-base](https://github.com/dkilcy/saltstack-base)

Install OpenStack Juno in a 3+ node architecture with neutron networking on CentOS 7.

![Node Deployment](notes/node-deployment.png "Node Deployment")

Contents:  

- states: SaltStack state files  
- pillar: SaltStack pillar data  
- notes : Documentation and sample configuration files  

##### Prerequesites

- Salt Master is installed on the utility (workstation) node.
- Salt Minion is installed on all OpenStack nodes. 

### Update Salt Master

1. Create /etc/salt/master.d/99-salt-envs.conf

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

2. Point Salt to the git repository: `ln -sf ~/git/juno-saltstack /srv/salt/openstack`
3. Restart the Salt Master: `systemctl restart salt-master.service`

### Update Salt Minions

From the Salt master:

1. Test connectivity to the pillars: `salt '*' test.ping`
2. Set the grains for each machine

 ```bash
salt 'controller*' grains.setvals "{'juno-saltstack':{'role':'controller'}}"
salt 'compute*' grains.setvals "{'juno-saltstack':{'role':'compute'}}"
salt 'network*' grains.setvals "{'juno-saltstack':{'role':'network'}}"
```

3. Refresh and sync the minions:

 ```bash
salt '*' saltutil.refresh_pillar
salt '*' saltutil.sync_all
```
