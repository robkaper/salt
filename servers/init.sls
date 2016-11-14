#!py
"""
servers/init.sls - include the server specific state if it exists
How it works:
  it makes a list of all the states available on the master (cp.list_states)
  and then checks if there is a state that matches the minion id, if so it
  adds it to the include list
Author: Jeffry Sleddens <j.p.g.sleddens@hr.nl>
Licensed under Apache License (https://raw.github.com/saltstack/salt/develop/LICENSE)
"""
def run():
    if 'id' in __grains__:
        minion_name = str(__grains__['id']).replace('.', '_')
        available_states = __salt__['cp.list_states']()
        if 'servers.' + minion_name in available_states:
            return { 'include' : ['servers.' + minion_name] }
    return {}
