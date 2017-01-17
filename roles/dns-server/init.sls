deploy-dns-zones:
  file.recurse:
    - name: /var/cache/bind
    - source: salt://files/bind/zones
    - user: bind
    - group: bind
    - file_mode: 640
    - dir_mode: 750

sign-dns-zones:
  cmd.run:
    - name: /usr/local/sbin/zonesigner.sh
    - cwd: /var/cache/bind/zonesigner
    - onchanges:
      - file: deploy-dns-zones
    - require:
      - file: deploy-zonesigner-script

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
      - file: deploy-dns-zones

Deploy BIND config:
  file.managed:
    - name: /etc/bind/named.conf.local
    - source: salt://files/bind/named.conf.local
    - user: bind
    - group: bind
    - mode: 640

deploy-zonesigner-cache-dir:
  file.directory:
    - name: /var/cache/bind/zonesigner
    - user: bind
    - group: bind
    - mode: 750
    - makedirs: True

deploy-zonesigner-script:
  file.managed:
    - name: /usr/local/sbin/zonesigner.sh
    - source: salt://files/bind/bin/zonesigner.sh
    - user: bind
    - group: bind
    - mode: 750
    - require:
      - file: deploy-zonesigner-cache-dir
