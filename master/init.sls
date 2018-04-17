include:
  - salt.repository

# Install and configure salt-master
salt-master:
  pkg.installed:
    - pkg: salt-master
  service.running:
    - enable: true
    - watch:
      - pkg: salt-master
      - file: /etc/salt/master

/etc/salt/master:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/master.jinja
    - template: jinja
    - defaults:
      interface: 10.13.37.1
      file_root: /etc/salt/file_root
      pillar_root: /etc/salt/pillar_root
    - require:
      - pkg: salt-master
