
### demo-tenant.md

#### Source the environment
```
source auth-openrc.sh 
source demo-openrc.sh 
```

#### Add keypair
```
nova keypair-add --pub-key ~/.ssh/id_rsa.pub demo-key
nova keypair-list
```

####
```
nova secgroup-add-rule default icmp -1 -1 0.0.0.0/0
nova secgroup-add-rule default tcp 22 22 0.0.0.0/0

nova secgroup-list
```

#### Create VM
```
nova boot \
  --flavor m1.tiny \
  --image cirros-0.3.3-x86_64 \
  --nic net-id=66456847-e3f2-47d1-9452-0f133894de50 \
  --security-group default \
  --key-name demo-key demo-instance1
  
nova list
```

#### Create floating IP
```
neutron floatingip-create ext-net
```

#### Associate floating IP with VM
```
nova floating-ip-associate demo-instance1 192.168.1.201
ping 192.168.1.201
```

### Example: Create VM from Ubuntu Trusty 14.04 LTS AMD-64 cloud image
```
[devops@workstation2 openstack]$ nova boot \
>   --flavor m1.medium \
>   --image trusty-server-cloudimg-amd64-disk1 \
>   --nic net-id=66456847-e3f2-47d1-9452-0f133894de50 \
>   --security-group default \
>   --key-name demo-key demo-trusty1
+--------------------------------------+---------------------------------------------------------------------------+
| Property                             | Value                                                                     |
+--------------------------------------+---------------------------------------------------------------------------+
| OS-DCF:diskConfig                    | MANUAL                                                                    |
| OS-EXT-AZ:availability_zone          | nova                                                                      |
| OS-EXT-STS:power_state               | 0                                                                         |
| OS-EXT-STS:task_state                | scheduling                                                                |
| OS-EXT-STS:vm_state                  | building                                                                  |
| OS-SRV-USG:launched_at               | -                                                                         |
| OS-SRV-USG:terminated_at             | -                                                                         |
| accessIPv4                           |                                                                           |
| accessIPv6                           |                                                                           |
| adminPass                            | fMCprUwWBSj8                                                              |
| config_drive                         |                                                                           |
| created                              | 2015-01-18T20:57:40Z                                                      |
| flavor                               | m1.medium (3)                                                             |
| hostId                               |                                                                           |
| id                                   | c43ca485-978a-41fb-a015-195ed9ab9529                                      |
| image                                | trusty-server-cloudimg-amd64-disk1 (4434873c-3d51-4be4-83b1-a4d43af58c26) |
| key_name                             | demo-key                                                                  |
| metadata                             | {}                                                                        |
| name                                 | demo-trusty1                                                              |
| os-extended-volumes:volumes_attached | []                                                                        |
| progress                             | 0                                                                         |
| security_groups                      | default                                                                   |
| status                               | BUILD                                                                     |
| tenant_id                            | fe232454f26a427b8f7577d919ea3120                                          |
| updated                              | 2015-01-18T20:57:40Z                                                      |
| user_id                              | 53d98d402a3d4d7789aff68a849fced1                                          |
+--------------------------------------+---------------------------------------------------------------------------+
[devops@workstation2 openstack]$ nova list
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
| ID                                   | Name           | Status | Task State | Power State | Networks                           |
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
| 51d0520d-195f-4141-a20c-eaf95e34be33 | demo-instance1 | ACTIVE | -          | Running     | demo-net=172.16.1.2, 192.168.1.201 |
| c43ca485-978a-41fb-a015-195ed9ab9529 | demo-trusty1   | BUILD  | spawning   | NOSTATE     |                                    |
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
[devops@workstation2 openstack]$ 
[devops@workstation2 openstack]$ nova list
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
| ID                                   | Name           | Status | Task State | Power State | Networks                           |
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
| 51d0520d-195f-4141-a20c-eaf95e34be33 | demo-instance1 | ACTIVE | -          | Running     | demo-net=172.16.1.2, 192.168.1.201 |
| c43ca485-978a-41fb-a015-195ed9ab9529 | demo-trusty1   | ACTIVE | -          | Running     | demo-net=172.16.1.6                |
+--------------------------------------+----------------+--------+------------+-------------+------------------------------------+
[devops@workstation2 openstack]$ 
[devops@workstation2 openstack]$ neutron floatingip-create ext-net
Created a new floatingip:
+---------------------+--------------------------------------+
| Field               | Value                                |
+---------------------+--------------------------------------+
| fixed_ip_address    |                                      |
| floating_ip_address | 192.168.1.204                        |
| floating_network_id | 84616cbd-c080-4773-8161-b4955a0fd08f |
| id                  | e564de71-b070-4ac1-9e30-6ee9db19220d |
| port_id             |                                      |
| router_id           |                                      |
| status              | DOWN                                 |
| tenant_id           | fe232454f26a427b8f7577d919ea3120     |
+---------------------+--------------------------------------+
[devops@workstation2 openstack]$ 
[devops@workstation2 openstack]$ nova floating-ip-associate demo-trusty1 192.168.1.204
[devops@workstation2 openstack]$ ping 192.168.1.201
PING 192.168.1.201 (192.168.1.201) 56(84) bytes of data.
64 bytes from 192.168.1.201: icmp_seq=1 ttl=63 time=3.07 ms
64 bytes from 192.168.1.201: icmp_seq=2 ttl=63 time=1.17 ms
^C
--- 192.168.1.201 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1001ms
rtt min/avg/max/mdev = 1.174/2.125/3.076/0.951 ms
[devops@workstation2 openstack]$ 
[devops@workstation2 openstack]$ ssh ubuntu@192.168.1.204
The authenticity of host '192.168.1.204 (192.168.1.204)' can't be established.
ECDSA key fingerprint is 67:34:96:44:ad:d5:05:c1:72:51:69:57:ce:a8:48:f4.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.1.204' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-44-generic x86_64)

 * Documentation:  https://help.ubuntu.com/

  System information as of Sun Jan 18 20:58:30 UTC 2015

  System load: 0.08              Memory usage: 1%   Processes:       59
  Usage of /:  56.3% of 1.32GB   Swap usage:   0%   Users logged in: 0

  Graph this data and manage this system at:
    https://landscape.canonical.com/

  Get cloud support with Ubuntu Advantage Cloud Guest:
    http://www.ubuntu.com/business/services/cloud

0 packages can be updated.
0 updates are security updates.



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

ubuntu@demo-trusty1:~$ ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default 
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether fa:16:3e:e3:ec:81 brd ff:ff:ff:ff:ff:ff
    inet 172.16.1.6/24 brd 172.16.1.255 scope global eth0
       valid_lft forever preferred_lft forever
    inet6 fe80::f816:3eff:fee3:ec81/64 scope link 
       valid_lft forever preferred_lft forever
ubuntu@demo-trusty1:~$ 

```


#### References

[Launch an instance with OpenStack Networking (neutron)][1]

[1]: http://docs.openstack.org/juno/install-guide/install/yum/content/launch-instance-neutron.html