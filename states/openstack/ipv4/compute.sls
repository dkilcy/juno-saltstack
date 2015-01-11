
teaming:
  pkg.installed:
    - name: teamd


{% from "openstack/ipv4/ip.jinja" import setup_team_intf with context %}
{% from "openstack/ipv4/ip.jinja" import setup_team_bond with context %}

###

{% set team = 'team0' %}
{% for intf in ['enp0s20f0','enp0s20f1'] %}
  {{ setup_team_intf( intf, team ) }}
{% endfor %}

{% set ipaddr = salt['grains.get']('openstack_mgmt_ip') %}
{{ setup_team_bond( team, ipaddr ) }}

###

{% set team = 'team1' %}
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

