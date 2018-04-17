include:
  - iptables

# Insert iptables rule right after initial rules (pos 8)
{% for v in [4, 6] %}
salt_master_iptables_ipv{{v}}:
  iptables.insert:
    - position: 5
    - family: ipv{{v}}
    - table: filter
    - chain: INPUT
    - jump: ACCEPT
    - match: state
    - connstate: NEW
    - dports: [4505, 4506]
    - proto: tcp
    - sport: 1025:65535
    - save: true
{% endfor %}
