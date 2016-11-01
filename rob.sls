User acccount for Rob:
  user.present:
    - name: rob
    - shell: /bin/bash
    - home: /home/{{ name }}
    - groups:
      - sudo
  group.present:
    - name: rob

Packages for Rob:
  pkg.installed:
    - pkgs:
      - joe
      - mutt

Files for Rob:
  file.managed:
    - name: {{ home }}/.joerc
    - source: salt://files/rob/.joerc
    - user: rob
    - group: rob
    - mode: 640
    - require:
      - pkg: joe
