install-security-packages:
  pkg.installed:
    - pkgs:
      - fail2ban

/etc/fail2ban/jail.local:
  file.managed:
    - name: /etc/fail2ban/jail.local
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
 
/etc/fail2ban/jail.local:
  file:
    - managed
    - source: salt://files/common/etc/fail2ban/jail.local
    - require:
      - pkg: fail2ban
 
{% if 'xmail-server' in grains['roles'] %}
/etc/fail2ban/filter.d/postfix-sasl.conf:
  file:
    - managed
    - source: salt://settings/fail2ban/mail/filter.d/postfix-sasl.conf
    - require:
      - pkg: fail2ban
 
/etc/fail2ban/filter.d/dovecot.conf:
  file:
    - managed
    - source: salt://settings/fail2ban/mail/filter.d/dovecot.conf
    - require:
      - pkg: fail2ban
 
/etc/fail2ban/filter.d/roundcube-auth.conf:
  file:
    - managed
    - source: salt://settings/fail2ban/mail/filter.d/roundcube-auth.conf
    - require:
      - pkg: fail2ban
{% endif %}
