#!/usr/bin/env python3
# PYTHON_ARGCOMPLETE_OK
import argparse
import argcomplete
import os.path as path
import subprocess

parser = argparse.ArgumentParser(
  prog='pdftopng.py',
  description='Helper function to convert PDF files to high quality PNG files'
  'for presentation needs')

parser.add_argument(
  'files', type=str,
  nargs='+').completer = argcomplete.FilesCompleter(allowednames='*.pdf')
parser.add_argument('-d',
                    '--density',
                    type=int,
                    default=300,
                    help='Pixel density (DPI/dots per inch)')
parser.add_argument('-q',
                    '--quite',
                    action='store_true',
                    help='Whether or not to print progress messages')

argcomplete.autocomplete(parser)
args = parser.parse_args()

for index, file in enumerate(args.files, start=1):
  ## Calculating file names and stuff
  filedir, infile = path.split(file)
  filename, ext = path.splitext(infile)
  if ext != '.pdf':
    print('Skipping over non-pdf file "%s"' % file)
    continue
  outfile = path.join(filedir, filename + '.png')

  ## Printing message
  if not args.quite:
    if len(args.files) > 1:
      print('[{0}/{1}] '.format(index, len(args.files)), end='')
    print('Converting file "{0}" to "{1}"... '.format(file, outfile),
          end='',
          flush=True)

  ## Running convert
  subprocess.run([
    'convert',  #
    '-density',
    str(args.density),  #
    '-trim',  #
    file,  #
    '-quality', '100',  #
    '-sharpen', '0x1.0',  #
    outfile
  ])

  ## Printing finish message
  if not args.quite:
    print('Done.')
