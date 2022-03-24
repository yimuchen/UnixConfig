"""
pykpb.py

Abstraction to allow for python scripts to extract login credentials from the
unlocked keepassxc database. The use of this file will assume that the database
has browser intergration features enabled. There will be hard-wired files that
are intentionally hidden from the user.
"""
import keepassxc_browser as kpb
import subprocess
import os
import sys
from pathlib import Path


def get_credentials(url: str):
  """
  Getting the credential information. As of KeepassXC version 2.7.0, entries are
  only searchable via the URL, be sure to enter the correct entries in the
  password entries "Browser Integration" section.
  """
  connection, identity = __make_kpb_connection__()
  logins = connection.get_logins(identity, url=url)
  if len(logins) == 0:
    raise ValueError("URL entry not found")
  elif len(logins) > 1:
    raise ValueError("Multiple values found for URL!")
  else:
    return logins[0]


def __get_identity_path__():
  """
  Generation of the file used to store the script association credentials. As
  this should be a persistent file to avoid having to reconfirm that the scripts
  have access regarding. To ensure extensibility of the process, here we save
  the file to a hidden file in the user home directory.
  """
  return os.getenv('HOME') + '/.pyscriptkeepass'


def __make_client_idstr__():
  """
  Making the client ID string. To ensure uniqueness of the string across
  different devices and users, the user client ID use the UUID of the root
  device (should be present for all UNIX based devices), and the UID of the
  user.
  """
  devices = subprocess.check_output(['lsblk', '-l']).decode('utf8').split('\n')
  home_dir = os.getenv('HOME')
  maxmatch = 0
  device = ''
  for d in devices:
    if not d: continue
    devpath = d.split()[-1]
    if home_dir.startswith(devpath) and len(devpath) > maxmatch:
      maxmatch = len(devpath)
      device = d.split()[0]
  UUID = subprocess.check_output(['lsblk', '-dno', 'UUID',
                                  f'/dev/{device}']).decode('utf8').strip()
  UID = os.getuid()
  return f'pyscript_keepass_{UUID}_{UID}'


def __make_kpb_connection__():
  """Default settings for getting a connection"""
  state_file = Path(__get_identity_path__())
  if state_file.exists():
    print("Reading identity file")
    with state_file.open('r') as f:
      data = f.read()
    identity = kpb.Identity.unserialize(__make_client_idstr__(), data)
  else:
    print("Identify file doesn't exist! Creating new")
    identity = kpb.Identity(__make_client_idstr__())

  connection = kpb.Connection()
  connection.connect()
  connection.change_public_keys(identity)

  if not connection.test_associate(identity):
    print('Not associated yet, associating now...')
    try:
      connection.associate(identity)
    except kpb.exceptions.ProtocolError as err:
      print("Database is not open! Check to see that keepassXC is open and unlocked")
      sys.exit(1)
    with open(__get_identity_path__(), 'w') as f:
      f.write(identity.serialize())
  return connection, identity


if __name__ == '__main__':
  print(__get_identity_path__())
  print(__make_client_idstr__())
  print(get_credentials('ssh://ndpc3'))
