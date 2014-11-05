### Workstation and Node setup

##### Overview

The environment consists of multiple bare-metal servers that serve the role of either **workstation** or **node**.
A **workstation** runs the CentOS 7 GNOME desktop.  It acts as the role of a utility node in OpenStack.  
It provides the following services for nodes:

- Repository mirror and Apache
- NTPD
- DHCP Server
- Salt Master
- 
The workstation is configured manually.

A **node** runs the CentOS 7 minimal install.  They are installed using an automated installer built with kickstart.

### Workstation Setup

Steps:

1. Install CentOS 7 GNOME desktop on Workstation  
2. Set security policies  
3. Configure GitHub and pull juno-saltstack  
4. Set the hosts file  
5. Add the EPEL and OpenStack repositories  
6. Create the repository mirror  
7. Setup apache  
8. Setup NTPD  
9. Setup DHCP server   
10. Setup salt master  
11. Create the kickstart image for nodes  

[Workstation Setup](workstation/README.md)

### Node Setup

Steps:

1. Install CentOS 7 minimal on node using kickstar image  
2. Accept minion key on salt master  
3. run highstate  

[a link](node/README.md)
