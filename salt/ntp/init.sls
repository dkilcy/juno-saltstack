
ntp:
  pkg.installed:
    - name: ntp

ntpd:
  service.running:
    - enable: True
    - restart: True
    - watch:
      - file: /etc/ntp.conf
      - pkg: ntp

/etc/ntp.conf:
  file.managed:
    - source: salt://ntp/ntp.conf
    - user: root
    - group: root
    - mode: 644

