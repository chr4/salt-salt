{% set master = pillar['salt']['master']|default({}) %}

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
      state_verbose: {{ master['state_verbose']|default(True) }}
      interface: {{ master['interface']|default("'::'") }}
      file_roots: {{ master['file_roots']|default() }}
      pillar_roots: {{ master['pillar_roots']|default() }}
      nodegroups: {{ master['nodegroups']|default() }}

    - require:
      - pkg: salt-master
