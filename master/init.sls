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
      state_verbose: {{ salt['pillar.get']('salt:master:state_verbose', True) }}
      interface: {{ salt['pillar.get']('salt:master:interface', "'::'") }}
      file_roots: {{ salt['pillar.get']('salt:master:file_roots') }}
      pillar_roots: {{ salt['pillar.get']('salt:master:pillar_roots') }}
      nodegroups: {{ salt['pillar.get']('salt:master:nodegroups') }}

    - require:
      - pkg: salt-master
