
### Ethernet Switches setup

Setup VLANS and trunks

##### Setup VLANs

1. Reuse VLAN 1 for .mgmt network
2. Create VLAN 2 for .vm network
3. Create VLAN 3 for .pub network

##### Setup Trunking between 2 switches


###### picoterm setup

```
sudo apt-get install picoterm
sudo picoterm /dev/ttyS0 -b 38400
```

Changing the IP address of the TP-Link Switch 
```
TL-SG3424>enable
TL-SG3216#configex
TL-SG3424(config)#show vlan
TL-SG3424(config)#interface vlan 1 
TL-SG3424(config-if)#ip address 10.0.0.2 255.255.255.0

ping 10.0.0.2
http://10.0.0.2
```
Web portal default account/password is admin/admin

### Set up VLANs

VLAN->VLAN Config Tab
Create VLAN 2 (VM) and assign ports, set Link Type for trunk ports
Create VLAN 3 (Public) and assign ports, set Link Type for trunk ports

### Setting up LAG (LACP)

Spannng Tree->STP Config tab
- Enable Spanning Tree Protocol (STP) on both switches 

Switching->LAG
Click LACP Config tab
24-port is priority over 16 port switches
- Select ports 15-16 or 23-24 
- For 23-24, use port priority 16384
- Click apply

#### References

[http://www.thomas-krenn.com/en/wiki/Link_Aggregation_and_LACP_basics]

