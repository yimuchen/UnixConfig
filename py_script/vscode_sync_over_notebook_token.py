#!/bin/env python3
import argparse
import os
import base64
#import urllib
import json
import requests

parser = argparse.ArgumentParser("""
  Simple script for uploading a list of files to a jupyter server session using
  the jupyter URL and token. This basically uses the same service as the
  `upload` button used in the jupyter lab session.

  The main reference is an response from stack-overflow. Here we re-write it as
  a standalone script to be called by the deploy-reloaded routine.
  https://stackoverflow.com/questions/29968829/load-local-data-into-ipython-notebook-server/41915132#41915132
  """)

parser.add_argument('filelist',
                    nargs='+',
                    type=str,
                    help="""
                    List of file to change (passed over by deploy reloaded""")
parser.add_argument('--localbase',
                    type=str,
                    required=True,
                    help="""
                    Working path of the plugin (from deploys inbuilt
                    variables)""")
parser.add_argument("--remotebase",
                    type=str,
                    required=True,
                    help='Path to remote directory')
parser.add_argument('--token',
                    type=str,
                    required=True,
                    help="Token used for access authentication.")
parser.add_argument('--serverurl',
                    type=str,
                    required=True,
                    help="Server URL that is hosting the jupyter server")

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument('--deploy', action='store_true')
group.add_argument('--pull', action='store_true')

def jupyter_upload(localfile, remotebase, jupyter_url, token):
  """
  Main function for uplodating to a jupyter notebook server. Taken from:

  https://stackoverflow.com/questions/29968829/
  load-local-data-into-ipython-notebook-server/41915132#41915132

  The URL of the request will be composed of 3 parts:

  <jupyter_url>/api/contents/<remotebase>/<path/to/file>

  The data of will be converted into base64
  """

  put_url = f'{jupyter_url}/api/contents/{remotebase}/{localfile}'
  headers = {"Authorization": f"token {token}"}

  with open(localfile, 'r') as f:
    data = f.read()
    data = data.encode('ascii')
    data = base64.b64encode(data).decode('ascii')
    data = json.dumps({
        'content': data,
        'name': os.path.basename(localfile),
        'path': localfile,
        'format': 'base64',
        'type': 'file'
    })

    return requests.put(put_url, data=data, headers=headers, verify=True)

## The main flow
args = parser.parse_args()

for file in args.filelist:
  # By default the args.filelist uses a full path. Here we are truncating it to
  # a relative path.
  localfile = file.replace(args.localbase, '')[1:]
  reldir = os.path.dirname(localfile)

  print('Local file:', localfile, reldir, args.localbase)
  print('Remote settings:', args.serverurl, args.remotebase)

  response = jupyter_upload(localfile=localfile,
                           remotebase=args.remotebase,
                           jupyter_url=args.serverurl,
                           token=args.token)
  print("Put response:", response)
