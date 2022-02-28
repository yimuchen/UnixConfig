#!/usr/bin/env python3
import subprocess
import argparse

parser = argparse.ArgumentParser(
  "gfal_sync.py", """
  Helper script to help sync the two directories over gfal remote file
  system""")
parser.add_argument("--source",
                    "-s",
                    type=str,
                    required=True,
                    help="""Source of files to copy, notice that this should be
                    a directory, not a single file""")
parser.add_argument("--destination",
                    "-d",
                    type=str,
                    required=True,
                    help="""Destination to copy the files. This should also be
                          a directory.""")
parser.add_argument("--run",
                    action='store_true',
                    help="""If set, the run the command, otherwise simply print
                         the command required to run on screen""")

args = parser.parse_args()


def make_file_list(redir):
  try:
    file_list = subprocess.check_output(['gfal-ls', '-l', redir])
    file_list = file_list.decode('utf-8').split('\n')
    file_list = [x.split() for x in file_list]
    file_list = {x[-1]: x[4] for x in file_list if len(x) > 5}
    return file_list
  except subprocess.CalledProcessError as err:
    print("Error calling command: ", err)
    return {}


source_list = make_file_list(args.source)
dest_list = make_file_list(args.destination)

print(args.run)
for file in source_list.keys():
  cmd = []
  if file not in dest_list:
    cmd = ['gfal-copy', f'{args.source}/{file}', f'{args.destination}/{file}']
  elif dest_list[file] != source_list[file]:
    cmd = [
      'gfal-copy', '-f', f'{args.source}/{file}', f'{args.destination}/{file}'
    ]
  else:
    pass

  if cmd:
    if not args.run:
      print(' '.join(cmd))
    else:
      subprocess.run(cmd)
