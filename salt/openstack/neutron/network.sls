{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}

{% from "openstack/neutron/ovs_common.jinja" import configure_ovs_common with context %}
{% from "openstack/neutron/networking_common.jinja" import configure_networking_common with context  %}

{% from "mariadb/map.jinja" import mysql with context %}

{% set mysql_host = salt['pillar.get']('openstack:controller') %}
{% set controller = salt['pillar.get']('openstack:controller') %}
{% set admin_token = salt['pillar.get']('openstack:ADMIN_TOKEN') %}
{% set mysql_root_password = salt['pillar.get']('mariadb:root_password') %}

{% set neutron_pass = salt['pillar.get']('openstack:NEUTRON_PASS') %}
{% set neutron_dbpass = salt['pillar.get']('openstack:NEUTRON_DBPASS') %}
{% set metadata_secret = salt['pillar.get']('openstack:METADATA_SECRET') %}

{% set instance_tunnels_interface_ip_address = salt['network.interfaces']()['team0']['inet'][0]['address'] %}

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.ip_forward:
  sysctl.present:
    - value: 1

load_sysctl_openstack_neutron:
  cmd.run:
    - name: sysctl -p

openstack_neutron:
  pkg.installed:
    - name: openstack-neutron

openstack_neutron_ml2:
  pkg.installed:
    - name: openstack-neutron-ml2

openstack_neutron_openvswitch:
  pkg.installed:
    - name: openstack-neutron-openvswitch

##########################################################################
{{ configure_rabbitmq( 'neutron_network', '/etc/neutron/neutron.conf' ) }}
{{ configure_identity( 'neutron_network', '/etc/neutron/neutron.conf', 'neutron', neutron_pass ) }}
{{ configure_networking_common( 'network' ) }}
{{ configure_ovs_common( 'network', instance_tunnels_interface_ip_address ) }}
####################################################################################

neutron_network_conf_flat_networks:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ml2_type_flat
    - parameter: flat_networks
    - value: external

neutron_network_bridge_mappings:
  openstack_config.present:
    - filename: /etc/neutron/plugins/ml2/ml2_conf.ini
    - section: ovs
    - parameter: bridge_mappings
    - value: 'external:br-ex'


## To configure the Layer-3 (L3) agent
## The Layer-3 (L3) agent provides routing services for virtual networks.
##    Edit the /etc/neutron/l3_agent.ini file and complete the following actions:

## a. In the [DEFAULT] section, configure the driver, enable network namespaces, and configure the external network bridge:

neturon_network_l3_conf_interface_driver:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: interface_driver
    - value: neutron.agent.linux.interface.OVSInterfaceDriver

neturon_network_l3_conf_use_namespaces:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: use_namespaces
    - value: 'True'

neturon_network_l3_conf_external_network_bridge:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: external_network_bridge
    - value: br-ex

neturon_network_l3_conf_verbose:
  openstack_config.present:
    - filename: /etc/neutron/l3_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'
 

neturon_network_dhcp_conf_if:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: interface_driver
    - value: neutron.agent.linux.interface.OVSInterfaceDriver

neturon_network_dhcp_conf_driver:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: dhcp_driver
    - value: neutron.agent.linux.dhcp.Dnsmasq

neturon_network_dhcp_conf_use_namespaces:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: use_namespaces
    - value: 'True'

neturon_network_dhcp_conf_verbose:
  openstack_config.present:
    - filename: /etc/neutron/dhcp_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'


neutron_metadata_agent_1:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: auth_url
    - value: http://{{ controller }}:5000/v2.0

neutron_metadata_agent_2:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT 
    - parameter: auth_region
    - value: regionOne

neutron_metadata_agent_3:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: admin_tenant_name
    - value: service

neutron_metadata_agent_4:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: admin_user
    - value: neutron

neutron_metadata_agent_5:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: admin_password
    - value: {{ neutron_pass }}

neutron_metadata_agent_6:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: nova_metadata_ip
    - value: {{ controller }}

neutron_metadata_agent_7:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: metadata_proxy_shared_secret
    - value: {{ metadata_secret }}

neutron_metadata_agent_8:
  openstack_config.present:
    - filename: /etc/neutron/metadata_agent.ini
    - section: DEFAULT
    - parameter: verbose
    - value: 'True'




openvswitch_service_start:
  service.running:
    - name: openvswitch

openvswitch_servce_enabled_on_boot:
  service.enabled:
    - name: openvswitch

openvswitch_add_integration_bridge:
  cmd.run:
    - name: ovs-vsctl add-br br-ex

# TODO: fix eth2
openvswitch_add_external_bridge_to_external_nic:
  cmd.run:
    - name: ovs-vsctl add-port br-ex eth2

# 
neutron_network_openvswitch_agent:
  file.copy:
    - name: /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
    - source: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - preserve: True

neutron_network_neutron_openvswitch_agent:
  file.replace:
    - name: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - path: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - pattern: plugins/openvswitch/ovs_neutron_plugin.ini
    - repl: plugin.ini

#
compute_openvswitch_agent_service_start:
  service.running:
    - name: neutron-openvswitch-agent

compute_openvswitch_agent_service_enabled_on_boot:
  service.enabled:
    - name: neutron-openvswitch-agent

compute_l3_agent_service_start:
  service.running:
    - name: neutron-l3-agent

compute_l3_agent_service_enabled_on_boot:
  service.enabled:
    - name: neutron-l3-agent

compute_dhcp_agent_service_start:
  service.running:
    - name: neutron-dhcp-agent

compute_dhcp_agent_service_enabled_on_boot:
  service.enabled:
    - name: neutron-dhcp-agent

compute_metadata_agent_service_start:
  service.running:
    - name: neutron-metadata-agent

compute_metadata_agent_service_enabled_on_boot:
  service.enabled:
    - name: neutron-metadata-agent


