
openstack-nova-network:
  pkg.installed:
    - name: openstack-nova-network

openstack-nova-api:
  pkg.installed:
    - name: openstack-nova-api

nova_network_network_api_class:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: network_api_class
    - value: nova.network.api.API

nova_network_security_group_api:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: security_group_api
    - value: nova

nova_network_firewall_driver:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: firewall_driver
    - value: nova.virt.libvirt.firewall.IptablesFirewallDriver

nova_network_network_manager:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: network_manager
    - value: nova.network.manager.FlatDHCPManager

nova_network_network_size:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: network_size
    - value: '254'

nova_network_allow_same_net_traffic:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: allow_same_net_traffic
    - value: 'False'

nova_network_multi_host:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: multi_host 
    - value: 'True'

nova_network_send_arp_for_ha:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: send_arp_for_ha
    - value: 'True'

nova_network_share_dhcp_address:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: share_dhcp_address
    - value: 'True'

nova_network_force_dhcp_release:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: force_dhcp_release
    - value: 'True'

nova_network_flat_network_bridge:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: flat_network_bridge
    - value: br100

nova_network_flat_interface:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: flat_interface
    - value: team1

nova_network_public_interface:
  openstack_config.present:
    - filename: /etc/nova/nova.conf
    - section: DEFAULT
    - parameter: public_interface
    - value: team1

openstack-nova-network-service:
  service.running:
    - name: openstack-nova-network
    - enable: True

openstack-nova-api_service:
  service.running:
    - name: openstack-nova-api
    - enable: True

openstack-nova-network-service_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-network

openstack-nova-api_enabled_on_boot:
  service.enabled:
    - name: openstack-nova-api

