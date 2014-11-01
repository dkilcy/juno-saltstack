
### Ethernet Switches setup

Setup VLANS and trunks

##### Setup VLANs

1. Create VLAN 1 for mgmt
2. Create VLAN 2 for pub
3. Create VLAN 3 for vm

##### Setup Trunking between 2 switches


###### picoterm setup

```
sudo apt-get install picoterm
sudo picoterm /dev/ttyS0 -b 38400
```

Changing the IP address 
```
TL-SG3424>enable
TL-SG3424(config)#show vlan
TL-SG3424(config)#interface vlan 1 
TL-SG3424(config-if)#ip address 10.0.0.2 255.255.255.0

ping 10.0.0.2
http://10.0.0.2
admin/admin

```

