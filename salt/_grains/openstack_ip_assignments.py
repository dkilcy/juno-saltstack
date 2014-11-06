# salt '*' saltutil.sync_grains

import socket

def openstack_ip_assignments():
    grains = {} 
    grains['openstack_mgmt_ip'] = get_ip_assignment('.mgmt')
    grains['openstack_vm_ip'] = get_ip_assignment('.vm')
    grains['openstack_pub_ip'] = get_ip_assignment('.pub')
    return grains

def get_ip_assignment(domain):
    try:
      return socket.gethostbyname(socket.gethostname() + domain)
    except Exception as e:
      return None

if __name__=='__main__':
    print socket.gethostname()
    print openstack_ip_assignments()

