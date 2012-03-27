#!/usr/bin/python

import os
import re
import subprocess
import sys

def get_sessions():
  process = subprocess.Popen(['/usr/bin/tmux', 'list-sessions'],
                             stdout = subprocess.PIPE,
                             stderr = subprocess.PIPE)
  output, errors = process.communicate()
  sessions = []
  for line in output.split('\n'):
    if line.find('window') > 0:
      idx = line.find(':')
      if idx > 0:
        sessions.append(line[:idx])
  return sorted(sessions)

def get_clients():
  cmd = ['/bin/bash', '-c', 'ls /home/$USER/clients']
  process = subprocess.Popen(cmd,
                             stdout = subprocess.PIPE,
                             stderr = subprocess.PIPE)
  output, errors = process.communicate()
  clients = []
  for client in output.split('\n'):
    client = client.strip()
    if client:
      clients.append(client)
  return sorted(clients)

def print_options(command, prefix):
  if command == 'rsc':
    sessions = get_sessions()
    if prefix:
      sessions = [session for session in sessions
                  if session.startswith(prefix)]
    print '\n'.join(sessions)
  elif command == 'mksc':
    clients = get_clients()
    if prefix:
      clients = [client for client in clients
                 if client.startswith(prefix)]
    sessions = frozenset(get_sessions())
    for client in clients:
      if client not in sessions:
        print client

def main():
  if len(sys.argv) > 1:
    command = sys.argv[1]
    prefix = None
    if len(sys.argv) > 2:
      prefix = sys.argv[2]
    print_options(command, prefix)
  else:
    print '[Clients]'
    sessions = frozenset(get_sessions())
    for client in get_clients():
      if client not in sessions:
        print '  mksc %s' % client
    print
    print '[Live Sessions]'
    for session in get_sessions():
      print '  rsc %s' % session
    print

if __name__ == '__main__':
  try:
    main()
  except:
    pass
