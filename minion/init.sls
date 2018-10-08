{% set minion = pillar['salt']['minion']|default({}) %}

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
{% if minion['mines'] is defined %}
      - file: /etc/salt/minion.d/*
{% endif %}

/etc/salt/minion:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - source: salt://{{ slspath }}/minion.jinja
    - template: jinja
    - defaults:
      master: {{ minion['master']|default() }}
      master_finger: {{ minion['master_finger']|default() }}
      file_roots: {{ minion['file_roots']|default() }}
      pillar_roots: {{ minion['pillar_roots']|default() }}
    - require:
      - pkg: salt-minion

{% for name, _ in minion['mines']|dictsort %}
/etc/salt/minion.d/{{ name }}.conf:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents_pillar: salt:minion:mines:{{ name }}
{% endfor %}
