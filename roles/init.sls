#!python
"""
roles/init.sls - include the states for all roles of a server if they exist
How it works:
  it makes a list of all the states available on the master (cp.list_states)
  and then checks for every role defined on the minion role grain if a state
  with the same name as the role exists, if so add it to the include list
Author: Jeffry Sleddens <j.p.g.sleddens@hr.nl>
Licensed under Apache License (https://raw.github.com/saltstack/salt/develop/LICENSE)
"""

def run():
    config = {}
    print config
    if 'role' in __grains__:
        print __grains__
        role_states = []
        available_states = __salt__['cp.list_states']()
        print role
        for role in __grains__['role']:
            if 'roles.' + role in available_states:
                role_states.append('roles.' + role)
        if len(role_states) > 0:
            config = { 'include' : role_states }
    print config
    return config
