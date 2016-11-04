User acccount for Rob:
  user.present:
    - name: rob
    - shell: /bin/bash
    - home: /home/rob
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
    - name: /home/rob/.joerc
    - source: salt://files/rob/.joerc
    - user: rob
    - group: rob
    - mode: 640
    - require:
      - pkg: 'Packages for Rob'

install-cleanjoe:
  file.managed:
    - name: /usr/local/bin/cleanjoe
    - source: salt://files/rob/bin/cleanjoe
    - user: root
    - group: root
    - mode 755
