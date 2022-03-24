#!/usr/bin/env python3
import pykpb
import subprocess
import argparse
import argcomplete

parser = argparse.ArgumentParser(
  "keerdp.py", """
  Starting the remote desktop protocol with the password passed over from a
  KeePass database. You might still need to copy and paste the credentials if
  requested by the remote system. This program expect the existence of the
  xfreerdp command to launch a remote desktop protocol (freerdp in the
  ArchlLinux repository).""")

parser.add_argument("--hostname",
                    "-v",
                    type=str,
                    default='ndpc6',
                    help="""Where to log into the server. The server should also
                         have the user and password entries in the active
                         KeePassXC data base with the 'rdp://' prefix. The /u,
                         /v, and /p entires for the xfreexdp command will be
                         automatically filled using the credentials found""")
parser.add_argument("--args",
                    type=str,
                    default='/w:1920 /h:1080',
                    help="""Additional options to pass to the xfreexdp instance.
                         Default to set the output to a full HD screen""")
parser.add_argument('--dryrun',
                    action='store_true',
                    help="""If this flag is set, print the command on the screen
                      rather than running the command""")

args = parser.parse_args()
argcomplete.autocomplete(parser)

cred = pykpb.get_credentials(f'rdp://{args.hostname}')
cmd = [
  'xfreerdp',  #
  f'/v:{args.hostname}', f'/u:{cred["login"]}', f'/p:{cred["password"]}'
]

cmd += args.args.split()  # Splitting the additional arguments

if args.dryrun:
  print(' '.join(cmd))
else:
  subprocess.run(cmd)