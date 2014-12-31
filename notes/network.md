
### Network

##### Switch setup

1. Connect the USB console cable
2. Start minicom: `minicom -D /dev/ttyUSB0 -b 38400`

##### Set the external IP address
```
enable
configure
interface vlan 1
ip address 10.0.0.240 255.255.255.0
exit
exit
```

On TL-SG3216:
- System -> Device Description
  - Device Location: Lab


Create 3 VLANs
- Create VLAN 100
- Create VLAN 101
- Create VLAN 102

Other commands:
```
show vlan brief
show vlan id 1

show interface status 
show interface vlan 1             

show system-info
show ip http secure-server
```

##### References

[http://www.ccnpguide.com/end-to-end-vs-local-vlan-models/]
[http://www.informit.com/library/content.aspx?b=CCNP_Studies_Switching&seqNum=44]
[http://www.informit.com/library/content.aspx?b=CCNP_Studies_Switching&seqNum=18]
