#!/bin/env python3
import subprocess
import argparse
import argcomplete
import getpass
from pykeepass import PyKeePass

parser = argparse.ArgumentParser(
    'Starting a kerbose session with password stored in keepass database')

parser.add_argument(
    '--database','-d',
    type=str,
    default='/home/ensc/.ssh/Database.kdbx',
    help='Keepass database file that we are going to search for entries'
)

parser.add_argument(
    'domain',
    type=str,
    choices=['CERN', 'FNAL'],
    help=
    'Domain to connect to, currently only allows for CERN and FNAL identifications'
)

argcomplete.autocomplete(parser)
arg = parser.parse_args()

kp = PyKeePass( arg.database,
                password=getpass.getpass('Data base master password: ') )
group = kp.find_groups(name='Internet',first=True)
entry = kp.find_entries(title=arg.domain, first=True)
lines = entry.notes.splitlines()
kbsurl = next(line for line in lines if line.startswith('KERBOSE_URL') ).split()[1]

## Running the Kinit command
kinit = subprocess.run(
    ['/usr/bin/kinit', '%s@%s' % ( entry.username, kbsurl )],
    input=entry.password,
    encoding='ascii'
)