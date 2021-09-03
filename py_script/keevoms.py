#!/bin/env python3
import subprocess
import argparse
import argcomplete
import getpass
import sys
import os
import errno
from pykeepass import PyKeePass

parser = argparse.ArgumentParser(
    """Initializing a voms proxy certificate on some remote server using the
       credential stored in the keepass data base.""",
    formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument(
    '--database',
    '-d',
    default='{}/ArchConfig/AppConfig/Database.kdbx'.format(os.getenv('HOME')),
    help='Keepass database file that we are going to search for entries')

parser.add_argument(
    '--certificate',
    '-c',
    type=str,
    default='CERN GRID Certificate',
    help='Title of the keepass database entry to uses for password query')

parser.add_argument(
    '--servers',
    '-s',
    nargs='+',
    default=['fnal-default'],
    type=str,
    help="""List of ssh servers to initialized voms proxy, notice that the
    program expects to be able to run connect to the server via `ssh <server>`
    without any user inputs. Configuration ~/.ssh/config accordingly.
    """)

argcomplete.autocomplete(parser)
args = parser.parse_args()

## Openning the database
kp = []
try:
  kp = PyKeePass(args.database,
                 password=getpass.getpass('Data base master password: '))
except:
  print("Error opening database file")
  sys.exit(1)
# group = kp.find_groups(name='Internet', first=True)

for server in args.servers:
  print(f"Running voms-proxy-init for {server}")
  entry = kp.find_entries(title=args.certificate, first=True)
  cmd = f'ssh {server} voms-proxy-init -voms cms --valid 192:00'
  p = subprocess.Popen(cmd,
                       shell=True,
                       stdin=subprocess.PIPE,
                       stdout=subprocess.PIPE,
                       stderr=subprocess.PIPE)
  p.communicate(input=str.encode(entry.password + '\n'))
  p.wait()
