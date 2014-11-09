{% from "openstack/rabbitmq.jinja" import configure_rabbitmq with context %}
{% from "openstack/identity.jinja" import configure_identity with context %}
{% from "openstack/neutron/ovs_common.jinja" import configure_ovs_common with context %}
{% from "openstack/neutron/networking_common.jinja" import configure_networking_common with context  %}
{% from "openstack/neutron/compute_common.jinja" import configure_compute_common with context %}

{% set controller = salt['pillar.get']('openstack:controller') %}
{% set neutron_pass = salt['pillar.get']('openstack:NEUTRON_PASS') %}
{% set instance_tunnels_interface_ip_address = salt['network.interfaces']()['team1']['inet'][0]['address'] %}

net.ipv4.conf.default.rp_filter:
  sysctl.present:
    - value: 0

net.ipv4.conf.all.rp_filter:
  sysctl.present:
    - value: 0

#load_sysctl_openstack_compute:
#  cmd.run:
#    - name: sysctl -p

openstack_neutron_compute_ml2:
  pkg.installed:
    - name: openstack-neutron-ml2

openstack_neutron_compute_openvswitch:
  pkg.installed:
    - name: openstack-neutron-openvswitch

##########################################################################
{{ configure_rabbitmq( 'neutron_compute', '/etc/neutron/neutron.conf' ) }}
{{ configure_identity( 'neutron_compute', '/etc/neutron/neutron.conf', 'neutron', neutron_pass ) }}
{{ configure_networking_common( 'compute' ) }}
{{ configure_ovs_common( 'compute', instance_tunnels_interface_ip_address ) }}
{{ configure_compute_common( 'compute' ) }}
###########################################

neutron_compute_auth_strategy:
  openstack_config.present:
    - filename: /etc/neutron/neutron.conf
    - section: DEFAULT
    - parameter: auth_strategy
    - value: keystone

neutron_compute_openvswitch_agent:
  file.copy:
    - name: /usr/lib/systemd/system/neutron-openvswitch-agent.service.orig
    - source: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - preserve: True

neutron_compute_openvswitch_agent_replace:
  file.replace:
    - name: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - path: /usr/lib/systemd/system/neutron-openvswitch-agent.service
    - pattern: plugins/openvswitch/ovs_neutron_plugin.ini
    - repl: plugin.ini

## TODO : restart
openstack_nova_compute_service_running:
  service.running:
    - name: openstack-nova-compute
    - enable: True

openvswitch_service_running:
  service.running:
    - name: neutron-openvswitch-agent
    - enable: True

