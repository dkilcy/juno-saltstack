vim:
  pkg.installed:
    - name: {{ pillar['pkgs']['vim'] }}

/home/devops/.vimrc:
  file.managed:
    - source: salt://vim/.vimrc
    - mode: 644
    - user: devops
    - group: devops
