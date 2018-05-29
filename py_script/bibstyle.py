#!/bin/env python
#*******************************************************************************
#
#  Filename    : bibstyle.py
#  Description : A simple python script for calling `biber --tool` commands for
#                styling .bib files
#  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
#
#*******************************************************************************
import argparse
import subprocess

#-------------------------------------------------------------------------------
#   Input options
#-------------------------------------------------------------------------------
parser = argparse.ArgumentParser(
    prog='bibstyle.py',
    description="""
        Program to call a the `biber --tool` command for styling .bib files with default options
        """
)

parser.add_argument(
    '-i','--input', type=str, nargs='+', required=True,
    help='list of input files to process (requires at least one)'
)


def main():
    args = parser.parse_args()

    for filename in args.input:
        if not filename.endswith( '.bib' ):
            print ("Warning! input file not a .bib file!")

        # The master bib command
        cmd = """
        biber --tool --output-align --output-indent=2 --output-fieldcase=lower --output_encoding=UTF8 --output-file={0} {0} 
        """.format( filename )

        print(cmd)
        #os.system(cmd)




if __name__ == '__main__':
    main()
