#!/bin/env python
#*******************************************************************************
 #
 #  Filename    : dvdrip.py
 #  Description : Simple scripts for ripping a DVD into a standalone .iso file
 #  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
 #
#*******************************************************************************
import argparse
import subprocess
import os

#-------------------------------------------------------------------------------
#   Input options
#-------------------------------------------------------------------------------
parser = argparse.ArgumentParser(
    prog='dvdrip.py',
    description = 'Simple scripts for ripping a DVD into a standalone .iso file for documentation'
)

parser.add_argument(
    '-d','--device', type=str, default='/dev/sr0',
    help='Device of the DVD drive to read the DVD.'
)

parser.add_argument(
    '-o','--output', type=str, required=True,
    help='Output file name, the postfix is .iso will be automatically added.'
)

parser.add_argument(
    '-w', '--workpath', type=str, default='{}/.dvd_rip_tmp/'.format(os.environ['HOME']),
    help='Working directory for the operation scripts.'
)


def main():
    args = parser.parse_args()

    outputname = args.output  if args.output.endswith('.iso') else args.output + '.iso'

    mkdircmd = ['mkdir', '-p', args.workpath ]
    rmdircmd = ['rm',   '-rf', args.workpath ]

    backupcmd = ["dvdbackup",
        "-i" , args.device,
        "-o", args.workpath,
        "--mirror",
        "--progress",
        "--name={}".format("temp")
        ]

    makeisocmd = [ "mkisofs",
        "-dvd-video", "-udf",
        "-output", outputname,
        "{}/{}".format(args.workpath, "temp")]

    subprocess.Popen( mkdircmd ).wait()
    subprocess.Popen( backupcmd ).wait()
    subprocess.Popen( makeisocmd ).wait()
    subprocess.Popen( rmdircmd ).wait()

if __name__ == '__main__':
    main()
