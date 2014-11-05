### Workstation and Node setup

##### Overview

The environment consists of multiple bare-metal servers that serve the role of either **workstation** or **node**.  
A **workstation** runs the CentOS 7 GNOME desktop.  It acts as the role of a utility node in OpenStack.    
It provides the following services for nodes:

- Repository mirror and Apache
- NTPD
- DHCP Server
- Salt Master

The workstation is configured manually.

A **node** runs the CentOS 7 minimal install.  They are installed using an automated installer built with kickstart.

### Workstation Setup

[Workstation Setup](workstation/README.md)

### Node Setup

Steps:

1. Install CentOS 7 minimal on node using kickstar image  
2. Accept minion key on salt master  
3. run highstate  

[Node Setup](node/README.md)
