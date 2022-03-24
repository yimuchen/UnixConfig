#!/bin/env python3
import subprocess
import argparse
import argcomplete
import getpass
import sys
import os
import errno
import pykpb

parser = argparse.ArgumentParser(
  """Starting kerberos tickets using credentials stored in the open keepass
  database.""",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('--sites',
                    '-s',
                    type=str,
                    nargs='+',
                    default=['FNAL.GOV', 'CERN.CH'],
                    help="""URL to look for in keepassXC database to use for
                    kerberos identity. The URL in the database should be
                    prefixed with the 'kerberos://' prefix.""")

argcomplete.autocomplete(parser)
args = parser.parse_args()

for domain in args.sites:
  cred = pykpb.get_credentials(f'kerberos://{domain}')
  ## Running the kinit command
  identity = '{}@{}'.format(cred['login'], domain)
  print('Generating for identity [{0}]...'.format(identity), end='')
  subprocess.run(['/usr/bin/kinit', identity],
                 input=cred['password'],
                 encoding='ascii',
                 stdout=subprocess.DEVNULL,
                 stderr=subprocess.DEVNULL)
  print('Done!')
