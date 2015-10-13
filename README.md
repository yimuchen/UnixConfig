# Unix Configuration File

This is my settings files for unix system. Including

 1. `vim` setting and plugin configurations 
 2. `zsh` settings and aliases 
 3. `git` default files (gitignore and Licences)
 3. `Conky` configurations 
 4. `Latex` templates and custom functions
 5. `i3` configuration file
 6. `terminator` configuration file
 7. `astyle` configuration files
 8. Custom script files that could be run directly from the command line

 To deploy the configuration simply execute the Script `Setup.sh`, this will link the file to the `$HOME`
 directory as hidden files. Notice that this will remove previous existence of the configuration files if it 
 previously existed.

##  Prerequisites (Using Archliunx repositories)

   1. `vim` 
   2. `zsh`
   3. `git`
   4. `astyle`
   5. `texlive-most`
   6. `conky`
   7. `i3`
   8. `terminator`

Fonts handling is not performed by this script package, Here is a list of the required fonts for all 
of the packages to functions properly.

   1. ttf-linux-libertine 
   2. powerline-fonts-git
   3. cwtex-q-fonts
