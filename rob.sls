User acccount for Rob:
  user.present:
    - name: rob
    - shell: /bin/bash
    - home: /home/rob
    - groups:
      - sudo

Packages for Rob:
  pkg.installed:
    - pkgs:
      - joe
      - mutt
