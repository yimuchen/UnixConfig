# Unix Configuration File

This is my settings files for unix system. Including

 * [`vim`](https://wiki.archlinux.org/index.php/vim) setting and plugin configurations
 * [`zsh`](https://wiki.archlinux.org/index.php/zsh) settings and aliases
 * `git` default files (gitignore and Licences)
 * [`Conky`](https://wiki.archlinux.org/index.php/conky) configurations
 * [`Latex`](https://wiki.archlinux.org/index.php/TeX_Live) custom templates and
 * [`i3`](https://wiki.archlinux.org/index.php/i3) configuration file
 * Custom [python3](https://wiki.python.org/moin/Python2orPython3) scripts and packages to assist with common tasks.
 * Essential [atom](https://flight-manual.atom.io/using-atom/sections/basic-customization/) configuration files.

To deploy the configuration simply execute the Script `Setup.sh`, this will link the file to the `$HOME` directory as hidden files. Notice that this will remove previous existence of the configuration files if it previously existed. Since atom provides it's own package manager and package synchronisation, only very specific configuration files, where configuration via direct editing is required, will be added to this package.

##  Required packages (Using Archliunx repository names)
In no specific order,
 * `vim`
 * `zsh`
 * `git`
 * `astyle`
 * `texlive-most`
 * `conky`
 * `tmux`
 * `uncrustify`
 * `i3`
 * `python`

Fonts handling is not performed by this script package. Here is a list of fonts required to allow font-related settings to functions properly.

 * ttf-linux-libertine
 * noto-fonts-cjk
 * otf-xits
 * adobe-source-code-pro-fonts
