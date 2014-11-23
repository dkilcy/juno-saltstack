
#net.ipv6.conf.all.disable_ipv6:
#  sysctl.present:
#    - name: net.ipv6.conf.all.disable_ipv6
#    - value: 1

net.ipv6.conf.all.disable_ipv6:
  file.append:
    - name: /etc/sysctl.conf
    - text:
      - net.ipv6.conf.all.disable_ipv6=1

load_sysctl:
  cmd.run:
    - name: sysctl -p

