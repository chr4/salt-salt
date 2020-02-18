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
{% if salt.pillar.get('salt:minion:mines', undefined) is defined %}
      - file: /etc/salt/minion.d/*
{% endif %}

/etc/salt/minion:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ tpldir }}/minion.jinja
    - template: jinja
    - defaults:
      master: {{ salt.pillar.get('salt:minion:master') }}
      master_finger: {{ salt.pillar.get('salt:minion:master_finger') }}
      ipv6: {{ salt.pillar.get('salt:minion:ipv6', False) }}
      state_verbose: {{ salt.pillar.get('salt:minion:state_verbose', True) }}
      file_roots: {{ salt.pillar.get('salt:minion:file_roots') }}
      pillar_roots: {{ salt.pillar.get('salt:minion:pillar_roots') }}
    - require:
      - pkg: salt-minion

{% for name, _ in salt.pillar.get('salt:minion:mines', {})|dictsort %}
/etc/salt/minion.d/{{ name }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: salt:minion:mines:{{ name }}
{% endfor %}
