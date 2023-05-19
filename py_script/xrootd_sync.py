#!/usr/bin/env python3
import subprocess
import argparse
import os
import re
import sys

parser = argparse.ArgumentParser(
  "xrootd_sync.py", """
  Helper script to help sync the two directories over xrootd remote file
  system""")
parser.add_argument("--source",
                    "-s",
                    type=str,
                    required=True,
                    help="""Source of files to copy, notice that this should be
                    a directory, not a single file""")
parser.add_argument("--dest",
                    "-d",
                    type=str,
                    required=True,
                    help="""Destination to copy the files. This should also be
                          a directory.""")
parser.add_argument("--run",
                    action='store_true',
                    help="""If set, the run the command, otherwise simply print
                         the command required to run on screen""")



def make_file_list(redir):
  """
  Making the a list of files in the remote directory
  """
  try:
    site_pattern = re.compile(r'root://[a-z\.\:0-9--]+/')
    site = site_pattern.match(redir)[0]
    directory = redir.replace(site, '')
    file_list = subprocess.check_output(['xrdfs', site, 'ls', '-l', directory])
    file_list = file_list.decode('utf-8').split('\n')
    file_list = [x.split() for x in file_list]
    file_list = {os.path.basename(x[-1]): x[3] for x in file_list if len(x) >= 5}
    return file_list
  except TypeError as err:
    if 'subscriptable' in str(err):
      raise RuntimeError('Unrecognized remote address', redir)
    else:
       raise err
  except subprocess.CalledProcessError as err:
    if 'Login incorrect' in str(err):
      print('Login error, trying again')
      return make_file_list(redir)
    else:
      print("Error calling command: ", err)
      return {}


if __name__ == '__main__':
  args = parser.parse_args()
  source_list = make_file_list(args.source)
  dest_list = make_file_list(args.dest)
  matched = True

  for file in source_list.keys():
    cmd = []
    if file not in dest_list:
      matched = False
      cmd = ['xrdcp', f'{args.source}/{file}', f'{args.dest}/{file}']
    elif dest_list[file] != source_list[file]:
      matched = False
      print(dest_list[file], source_list[file])
      cmd = ['xrdcp', '-f', f'{args.source}/{file}', f'{args.dest}/{file}']
    else:
      pass # Do nothing

    if cmd:
      if not args.run:
        print(' '.join(cmd))
      else:
        subprocess.run(cmd)

  if matched:
    print('All files found and matched in destination')
