#!/bin/env python
#*******************************************************************************
 #
 #  Filename    : Setup.py
 #  Description : Setup script for linking objects into home directory
 #  Author      : Yi-Mu "Enoch" Chen [ ensc@hep1.phys.ntu.edu.tw ]
 #
#*******************************************************************************
import os
import prompt
import subprocess

sourcedir = os.path.dirname(os.path.realpath(__file__))
homedir   = os.environ["HOME"]
special = [ "Setup.py", "README.md", "LICENSE", "TexSettings", "atom", ]

def main():
    softlink()
    installvim()
    linktex()
    linkatom()


def softlink():
    """
    Soft link process except for special directories
    """
    print ("Soft linking files in {0} to {1}".format(sourcedir,homedir))

    for filename in os.listdir(sourcedir):
        # ignoring special files
        if filename in special     : continue
        # ignoring configuration file for this package
        if filename.startswith('.'): continue

        sourcepath = os.path.join(sourcedir,filename)
        targetpath = os.path.join(homedir,'.'+filename)
        print( sourcepath, '->', targetpath )

        # Clearing symbolic links
        if os.path.islink(targetpath):
            print( "Removing existing symbolic link", targetpath )
            print( "rm -rf " + targetpath )
            subprocess.call( ["rm","-rf",targetpath] )

        # Query if already exists as regular file
        elif os.path.exists( targetpath ):
            if prompt.prompt( "Warning! Target " + targetpath + " already exists! Remove the existing path?" ):
                subprocess.call(["rm","-rf",targetpath] )
            else:
                print("Warning! Skipping over project:", sourcepath )

        # Linking source file:
        print( "Soft linking:", sourcepath, '->', targetpath )
        subprocess.call( ["ln","-s",sourcepath,targetpath] )

def installvim():
    basedir   = os.path.join(homedir,".vim","bundle")
    vundledir = os.path.join(basedir,"Vundle.vim")

    if os.path.isdir( vundledir ):
        return ## Vundle install, skipping
    elif os.path.exists( vundledir ):
        if prompt.prompt('Warning! File '+ vundledir + ' already exists! Remove the existing path?'):
            subprocess.call(['rm','-rf',vundledir])
        else:
            print('Please manually install the vim package manager Vundle.')
    else:
        print('First installation of vim plugins! Installing fresh version of Vundle')
        subprocess.call(["mkdir","-p",basedir])
        subprocess.call(["git","clone","https://github.com/gmarik/Vundle.vim.git","~/.vim/bundle/Vundle.vim/"])
        print('Manually install defined plugins via the ":PluginUpdate" command in a vim session')


def linktex():
    texmfdir = os.path.join(homedir,'texmf','tex')
    latexdir = os.path.join( texmfdir , 'latex')
    sourcepath = os.path.join( sourcedir, 'TexSettings' )

    if not os.path.exists( texmfdir ):
        subprocess.call(['mkdir', '-p', texmfdir])

    if os.path.islink( latexdir ):
        subprocess.call( ['rm', '-rf','latexdir'] )

    subprocess.call(['ln','-sf',sourcepath,latexdir])


def linkatom():
    targetdir = os.path.join( homedir, '.atom' )
    atomdir = os.path.join( sourcedir, 'atom' )

    if not os.path.isdir( targetdir ):
        print( "Atom directory doesn't exist! Please install atom on your system!")
        return

    for filename in os.listdir(atomdir):
        sourcepath = os.path.join( atomdir, filename )
        targetpath = os.path.join( targetdir, filename )

        if os.path.islink(targetpath):
            print( "Removing existing symbolic link", targetpath )
            print( "rm -rf " + targetpath )
            subprocess.call( ["rm","-rf",targetpath] )

        # Query if already exists as regular file
        elif os.path.exists( targetpath ):
            if prompt.prompt( "Warning! Target " + targetpath + " already exists! Remove the existing path?" ):
                print( "rm -rf "+targetpath )
                subprocess.call(["rm","-rf",targetpath] )
            else:
                print("Warning! Skipping over project:", sourcepath )

        # Linking source file:
        print( "Soft linking:", sourcepath, '->', targetpath )
        subprocess.call( ["ln","-s",sourcepath,targetpath] )



if __name__ == '__main__':
    main()
