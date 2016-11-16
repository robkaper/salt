install-security-packages:
  pkg.installed:
    - pkgs:
      - fail2ban

/etc/fail2ban/jail.local:
  file.managed:
    - source: salt://files/common/etc/fail2ban/jail.local
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: install-security-packages

fail2ban:
  pkg:
    - installed
  service:
    - running
    - require:
      - pkg: fail2ban
    - watch:
      - file: /etc/fail2ban/jail.local
 