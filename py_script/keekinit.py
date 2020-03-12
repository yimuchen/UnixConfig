#!/bin/env python3
import subprocess
import argparse
import argcomplete
import getpass
import sys
import os
from pykeepass import PyKeePass

parser = argparse.ArgumentParser(
    'Starting a kerbose session with password stored in keepass database')

parser.add_argument(
    '--database',
    '-d',
    type=str,
    default='/home/ensc/ArchConfig/AppConfig/Database.kdbx',
    help='Keepass database file that we are going to search for entries')

argcomplete.autocomplete(parser)
arg = parser.parse_args()

kp = []
try:
    kp = PyKeePass(arg.database,
               password=getpass.getpass('Data base master password: '))
except:
    print("Error opening database file")
    sys.exit(1)
group = kp.find_groups(name='Internet', first=True)

for domain in ['CERN', 'FNAL']:
  entry = kp.find_entries(title=domain, first=True)
  lines = entry.notes.splitlines()
  url = next(line for line in lines if line.startswith('KERBOSE_URL')).split()[1]

  ## Running the Kinit command
  kinit = subprocess.run([
      '/usr/bin/kinit',
      '{}@{}'.format(entry.username, url),
      '-c',
      '/tmp/kerberos_{}_{}'.format(os.getenv('USER'),domain)
  ],
                         input=entry.password,
                         encoding='ascii')
