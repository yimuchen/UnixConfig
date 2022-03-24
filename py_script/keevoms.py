#!/bin/env python3
import subprocess
import argparse
import argcomplete
import pykpb

parser = argparse.ArgumentParser(
  """
  Initializing a voms proxy certificate on some remote server over ssh command
  passing using the credential stored in the keepass database.""",
  formatter_class=argparse.ArgumentDefaultsHelpFormatter)

parser.add_argument('--certificate',
                    '-c',
                    type=str,
                    default='default_cert',
                    help="""Dummy URL used to identify the certificate
                         credentials. The URL should be prefix with cert:// in
                         the database.""")

parser.add_argument('--servers',
                    '-s',
                    nargs='+',
                    default=[
                      'fnal-default', 'lxplus7-bash',  #
                      'umdcms-bash', 'cmsconnect-default'
                    ],
                    type=str,
                    help="""List of ssh servers where you want to initialize
                          your voms proxy. These should be the ssh servers that
                          can be connect directly with the `ssh <server>`
                          command without any additional input.""")

argcomplete.autocomplete(parser)
args = parser.parse_args()

cred = pykpb.get_credentials(f'cert://{args.certificate}')

## Looping over
for server in args.servers:
  try:
    print(f"Running voms-proxy-init for {server}")
    ssh_cmd = ['ssh', server]
    voms_cmd = [
      'voms-proxy-init',  # Main command
      '-voms', 'cms',  # Virtual organization
      '--valid', '192:00',  # Valid time (8 days by default)
      '--out',
      '\'${HOME}/x509up_u${UID}\''  # proxy file in single quotes for env expansion
    ]
    cmd = ' '.join(ssh_cmd + voms_cmd)
    p = subprocess.Popen(cmd,
                         shell=True,
                         stdin=subprocess.PIPE,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE)
    p.communicate(input=str.encode(cred['password'] + '\n'))
    p.wait()
  except Exception as err:
    print("Error in configuration:", err)
