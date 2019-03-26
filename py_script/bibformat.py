#!/bin/env python3
# PYTHON_ARGCOMPLETE_OK
import re
import sys
import argparse
import argcomplete
import bibtexparser

#-------------------------------------------------------------------------------
#   Defining input options
#-------------------------------------------------------------------------------
parser = argparse.ArgumentParser(
    prog='bibformat.py',
    description=
    'Stripping down input .bib files to the entires specified in a .aux file with standard journal abbreviation and formatting for CMS TDR'
)
parser.add_argument(
    '--bib', type=str, nargs='+', required=True,
    help='List of input .bib files').completer = argcomplete.FilesCompleter(
        allowednames='*.bib')
parser.add_argument(
    '--aux', type=str, required=True,
    help='.aux file to process').completer = argcomplete.FilesCompleter(
        allowednames='*.aux')
parser.add_argument(
    '--output', type=str, default='bibformat.bib', help='output .bib file')

argcomplete.autocomplete(parser)
args = parser.parse_args()

## Processing all the input bib file
masterbib = bibtexparser.bibdatabase.BibDatabase()
for bibfile in args.bib:
  with open(bibfile) as inputfile:
    bib_database = bibtexparser.load(inputfile)
    masterbib.entries.extend(bib_database.entries)

# Getting the unique cite entires in .aux file
citeentrylist = []
with open(args.aux) as auxfile:
  for line in auxfile:
    m = re.match(r'\\citation\{(.*)\}', line)
    if m:
      citeentrylist.extend(m.group(1).split(','))
citeentrylist = set(citeentrylist)  # reduce to unique

# Creating new bib file
reducedbib = masterbib
reducedbib.entries = [x for x in masterbib.entries if x['ID'] in citeentrylist]

# Processing the entires according to typical TDR requirements
for entry in reducedbib.entries:
  if 'note' in entry:
    print("NOTE entry found!", entry['note'])

  # Page formatting
  if 'pages' in entry:
    entry['pages'] = re.sub(r'^0*', '', entry['pages'])
    entry['pages'] = re.sub(r'[\D].*', '', entry['pages'])
    # Stripping everything after a non digit character

  # Collaboration formatting
  if 'collaboration' in entry:
    entry['collaboration'] = re.sub(
        'collaboration', '', entry['collaboration'], flags=re.I)

  # Journal abbreviation
  if 'journal' in entry:
    # JHEP settings
    if 'Journal of High Energy Physics' in entry['journal']:
      entry['journal'] = 'JHEP'
      if 'number' in entry:
        entry['volume'] = entry['number']
        entry.pop('number')

    elif 'Physics Review Letter' in entry['journal']:
      letter = ''
      if entry['volume'][0].isalpha():
        letter = entry['volume'][0]
      entry['volume'] = entry['volume'][1:]
      entry['journal'] = 'Phys. Lett. ' + letter

    elif 'Physics Review' in entry['journal']:
      entry['journal'] = entry['journal'][len('Physics Review'):]
      entry['journal'] = 'Phys. Rev.' + entry['journal']

    elif 'European Physics Journal' in entry['journal']:
      letter = entry['volume'][0]
      entry['journal'] = 'Eur. Phys. J. ' + letter
      entry['volume'] = entry['volume'][1:]

    elif 'Journal of Instrumentation' in entry['journal']:
      entry['journal'] = 'JINST'

    elif 'Nuclear Instruments and Methods' in entry['journal']:
      original = entry['journal']
      newname = 'Nucl. Instrum. Meth.'
      if 'Section A' in original:
        newname = newname + ' A'
      entry['journal'] = newname

    elif 'Computer Physics Communication' in entry['journal']:
      entry['journal'] = 'Comput. Phys. Commun.'

    elif 'Chinese Physics ' in entry['journal']:
      entry['journal'] = re.sub('Chinese Physics', 'Chin. Phys.',
                                entry['journal'])

  # Removing unwanted entries
  entry.pop('abstract', None)
  entry.pop('slaccitation', None)
  entry.pop('month', None)
  entry.pop('institution', None)
  entry.pop('address', None)
  entry.pop('number', None)

  # Reassigning reportnumber to number entry
  if 'reportnumber' in entry and 'type' in entry:
    entry['number'] = entry['reportnumber']
    entry.pop('reportnumber')

# Printing to file
with open(args.output, 'w') as outputfile:
  for entry in reducedbib.entries:
    entrystring = '@{0}{{{1},\n'.format(entry['ENTRYTYPE'],entry['ID'])
    for field in [x for x in entry if x not in ['ENTRYTYPE', 'ID']]:
      fieldstring = entry[field]
      if 'author' in field and 'Collab' in fieldstring:
        fieldstring = '"{{ {0} }}"'.format(fieldstring)
      else:
        fieldstring = '{{{0}}}'.format(fieldstring)
      entrystring += '    {0} = {1},\n'.format(field,fieldstring)
    entrystring += '}\n\n'

    outputfile.write(entrystring)
