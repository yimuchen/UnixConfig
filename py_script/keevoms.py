#!/bin/env python3
import subprocess
import argparse
import argcomplete
import getpass
import sys
import os
import errno
import configparser
from pykeepass import PyKeePass

parser = argparse.ArgumentParser(
  """Initializing a voms proxy certificate on some remote server using the
  credential stored in the keepass database. Notice that the remote machine
  connection settings will also be stored in the Keepass database to allow for
  more complex settings.""",
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
  default=['FNAL', 'CERN', 'UMDCMS', 'CMSCONNECT'],
  type=str,
  help="""List of ssh servers to initialized voms proxy. These should be stored
       in the notes part of the KeePass database, and the corresponding machine
       should be able to log in without any additional input""")

argcomplete.autocomplete(parser)
args = parser.parse_args()

## Opening the database
kp = []
try:
  kp = PyKeePass(args.database,
                 password=getpass.getpass('Data base master password: '))
except:
  print("Error opening database file")
  sys.exit(1)
entry = kp.find_entries(title=args.certificate, first=True)
server_settings = configparser.ConfigParser()
server_settings.read_string(entry.notes)

## Looping over
for server in args.servers:
  try:
    print(f"Running voms-proxy-init for {server}")
    machine = server_settings[server]['machine']
    krb5 = server_settings[server].get('KRB_FILE', '')
    krb5 = krb5.replace('${UID}', str(os.getuid()))

    ssh_cmd = ['ssh', machine]
    voms_cmd = [
      'voms-proxy-init',  # Main command
      '-voms', 'cms',  # Virtual organization
      '--valid', '192:00',  # Valid time
      '--out', '\'${HOME}/x509up_u${UID}\''  # source file
    ]
    cmd = ' '.join(ssh_cmd + voms_cmd)
    p = subprocess.Popen(cmd,
                         shell=True,
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         env={'KRB5CCNAME': krb5})
    p.communicate(input=str.encode(entry.password + '\n'))
    p.wait()
  except Exception as err:
    print("Error in configuration:", err)
