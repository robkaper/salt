deploy-dns-zones:
  file.recurse:
    - name: /var/cache/bind-salt
    - source: salt://files/bind/zones
    - user: bind
    - group: bind
    - file_mode: 640
    - dir_mode: 750

sign-dns-zones:
  cmd.wait:
    - name: /usr/local/sbin/zonesigner.sh
    - cwd: /var/cache/bind/zonesigner
    - onchanges:
      - cmd: deploy-dns-zones

bind9:
  pkg.installed:
    - pkgs:
      - bind9
      - bind9utils
      - dnssec-tools
  user.present:
    - name: bind
  group.present:
    - name: bind
  service.running:
    - reload: True
    - watch:
      - file: /etc/bind/named.conf.local
    - onchanges:
      - cmd: deploy-dns-zones
      - cmd: sign-dns-zones

Deploy BIND config:
  file.managed:
    - name: /etc/bind/named.conf.local
    - source: salt://files/bind/named.conf.local
    - user: bind
    - group: bind
    - mode: 640

Deploy zonesigner script:
  file.managed:
    - name: /usr/local/sbin/zonesigner.sh
    - source: salt://files/bind/bin/zonesigner.sh
    - user: bind
    - group: bind
    - mode: 750
