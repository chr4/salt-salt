# Setup official saltstack repository
saltstack_repo:
  pkgrepo.managed:
    - name: deb https://repo.saltproject.io/salt/py3/{{ grains['os']|lower }}/{{ grains['osrelease'] }}/{{ grains['osarch'] }}/latest {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/saltstack.list
    - key_url: https://repo.saltproject.io/salt/py3/{{ grains['os']|lower }}/{{ grains['osrelease'] }}/{{ grains['osarch'] }}/latest/salt-archive-keyring.gpg
