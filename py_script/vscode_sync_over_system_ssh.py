#!/bin/env python3
"""
This script was written because the vscode deploy reloaded is no-longer being
actively maintained, and I would still like to keep a local copy for all my code
for a simpler package version control, and allow for editing even when I have not
access to the machine (like for documentation). The SCP communication package
used in the vscode deploy reloaded is very old, so it will not cope with all SSH
configurations of my use case such as machines that require kerberos login, and
machines that require ProxyJumps to access. This uses the python subprocess
package to perform system SCP calls, which allows for any non-interactive
settings to be used.

This script explicitly disallows any SSH connections to be initiated with a user
password, as this will either be require the use type in a password, or require
the password to be saved in plain text in the .vscode/settings.json file.
"""

import argparse
import subprocess
import os

parser = argparse.ArgumentParser("""
  Simple program for to request the sending a file to a remote server using a
  system SCP call. Using this method, all user-wide configuration defined in
  ~/.ssh/config can be called.
  """)

parser.add_argument('filelist',
                    nargs='+',
                    type=str,
                    help="""List of file to push over (passed over by deploy
                    reloaded)""")
parser.add_argument("--kerberos",
                    type=str,
                    default='',
                    help='kerberos cache file to use')
parser.add_argument('--localbase',
                    type=str,
                    required=True,
                    help="""
                    Working path of the file to be sent over (from deploys
                    inbuilt variables)""")
parser.add_argument("--remotehost",
                    type=str,
                    required=True,
                    help="""Remote host (can any configuration in ~/.ssh/config
                    that does not require a user input""")
parser.add_argument("--remotebase",
                    type=str,
                    required=True,
                    help="""Path to store file on the remote machine remote
                    directory""")

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('--deploy', action='store_true')
group.add_argument('--pull', action='store_true')

args = parser.parse_args()

for file in args.filelist:
  relpath = file.replace(args.localbase, '')
  reldir = os.path.dirname(relpath)

  print('Local file:', file, relpath, args.localbase)
  print('Remote settings:', args.remotehost, args.remotebase)

  if args.deploy:
    try:
      subprocess.call([
        'ssh', args.remotehost, 'mkdir', '-p', '{}/{}'.format(
          args.remotebase, reldir)
      ],
                      env={'KRB5CCNAME': args.kerberos})

      subprocess.call([
        'scp', file, '{}:{}/{}'.format(args.remotehost, args.remotebase, relpath)
      ],
                      env={'KRB5CCNAME': args.kerberos})
    except Exception as e:
      print("Error raised running scp command:", e)

  # input('Press Enter to continue')