# salt '*' saltutil.sync_grains

import socket

def openstack_ip_assignments():
    grains = {} 

    try:
        grains['openstack_mgmt_ip'] = socket.gethostbyname(socket.gethostname() + '.mgmt')
    except Exception as e:
        pass

    try:
        grains['openstack_vm_ip'] = socket.gethostbyname(socket.gethostname() + '.vm')
    except Exception as e:
        pass

    try:
        grains['openstack_pub_ip'] = socket.gethostbyname(socket.gethostname() + '.pub')
    except Exception as e:
        pass

    return grains

if __name__=='__main__':
    print socket.gethostname()
    print openstack_ip_assignments()

