#!/bin/env python3
import argparse
import subprocess
import os

parser = argparse.ArgumentParser("""
  Simple program for wrapping around vscode deploy reloaded to work around none
  standard SSH configurations
  """)

parser.add_argument('filelist',
                    nargs='+',
                    type=str,
                    help="""
                    List of file to change (passed over by deploy reloaded""")
parser.add_argument("--kerberos",
                    type=str,
                    default='',
                    help='kerberos cache file to use')
parser.add_argument('--localbase',
                    type=str,
                    required=True,
                    help="""
                    Working path of the plugin (from deploys inbuilt
                    variables)""")
parser.add_argument("--remotehost",
                    type=str,
                    required=True,
                    help='Remote host (can use configuration in ~/.ssh/config')
parser.add_argument("--remotebase",
                    type=str,
                    required=True,
                    help='Path to remote directory')

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

  #input('Press Enter to continue')