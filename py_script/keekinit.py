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
  """Starting kerberos tickets using credentials stored in a keepass database""",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument(
  '--database',
  '-d',
  type=str,
  default='{}/ArchConfig/AppConfig/Database.kdbx'.format(os.getenv('HOME')),
  help='Keepass database file that we are going to search for entries')
parser.add_argument(
  '--sites',
  '-s',
  type=str,
  nargs='+',
  default=['FNAL', 'CERN'],
  help='Entries in keepass database to use for kerberos identity generation')
parser.add_argument(
  '--default',
  type=str,
  default='FNAL',
  help="""Which kerberos identity to link to as the "default" kerberos cache at
  '/tmp/krb5cc_<USER_ID>'""")

argcomplete.autocomplete(parser)
args = parser.parse_args()

kp = None
try:
  kp = PyKeePass(args.database,
                 password=getpass.getpass('Data base master password: '))
except:
  print("Error opening database file")
  sys.exit(1)
#group = kp.find_groups(name='Internet', first=True)

kerberos_default = '/tmp/krb5cc_{}'.format(os.geteuid())

for domain in args.sites:
  entry = kp.find_entries(title=domain, first=True)
  lines = entry.notes.splitlines()
  url = next(line for line in lines if line.startswith('KERBOSE_URL')).split()[1]

  ## Running the Kinit command

  identity = '{}@{}'.format(entry.username, url)
  kerberos_file = '/tmp/kerberos_{}_{}'.format(os.geteuid(), domain)

  print('Generating for identity [{0}]...'.format(identity), end='')

  subprocess.run(['/usr/bin/kinit', identity, '-c', kerberos_file],
                 input=entry.password,
                 encoding='ascii',
                 stdout=subprocess.DEVNULL,
                 stderr=subprocess.DEVNULL)

  # Linking site to default
  if domain == args.default:
    print('Linking to default cache...', end='')
    try:
      os.symlink(kerberos_file, kerberos_default)
    except OSError as e:
      if e.errno == errno.EEXIST:
        os.remove(kerberos_default)
        os.symlink(kerberos_file, kerberos_default)
      else:
        raise e
  print('Done!')
