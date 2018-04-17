include:
  - salt.repository

# Configure salt-minion
salt-minion:
  pkg.installed: []
  service.running:
    - enable: true
    - watch:
      - pkg: salt-minion
      - file: /etc/salt/minion
      - file: /etc/salt/minion.d/*
      - file: /etc/hosts

/etc/salt/minion:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/minion.jinja
    - template: jinja
    - defaults:
      master: 10.13.37.1
    - require:
      - pkg: salt-minion
