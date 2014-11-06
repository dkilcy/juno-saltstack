
{% from "openstack/ipv4/ip.jinja" import setup_team_intf with context %}
{% from "openstack/ipv4/ip.jinja" import setup_team_bond with context %}

###

{% set ipaddr = salt['grains.get']('openstack.mgmt_ip') %}

enp0s20f0:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
    - ipaddr: {{ ipaddr }}
    - netmask: 255.255.255.0

enp0s20f1:
  network.managed:
    - enabled: True
    - type: eth
    - proto: none
  
{% set team = 'team0' %}
{% for intf in ['enp0s20f2','enp0s20f3'] %}
  {{ setup_team_intf( intf, team ) }}
{% endfor %}

{% set ipaddr = salt['grains.get']('openstack_vm_ip') %}
{{ setup_team_bond( team, ipaddr ) }}

restart_networking:
  cmd.wait:
    - name: systemctl restart network
    - watch:
      - file: '/etc/sysconfig/network-scripts/ifcfg-{{ team }}'

