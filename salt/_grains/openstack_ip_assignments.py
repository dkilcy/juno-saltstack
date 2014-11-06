# salt '*' saltutil.sync_grains

import socket

def openstack_mgmt_ip():
    return {
        'openstack_mgmt_ip': socket.gethostbyname(socket.gethostname()+'.mgmt')
    }

def openstack_vm_ip():
    return {
        'openstack_vm_ip' : socket.gethostbyname(socket.gethostname()+'.vm')
    }

def openstack_pub_ip():
    return {
        'openstack_pub_ip' : socket.gethostbyname(socket.gethostname()+'.pub')
    }

