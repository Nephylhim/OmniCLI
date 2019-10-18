# PKG

_Get informations on a package and its files_

___

## Description

pkg is a small utilitary CLI that gives you informations on files and commands's packages.

### Commands

* files
  List the files installed by a given package
* cmd
  Tell from which package came the given command
* file
  Tell from which package came the given file

### Usage

`pkg cmd ip`

```txt
iproute2: /bin/ip
```

`pkg files toilet`

```txt
gimp-data: /usr/share/gimp/2.0/icons/Color/scalable/apps/gimp-toilet-paper.svg
toilet: /usr/share/doc/toilet
toilet-fonts: /usr/share/doc/toilet-fonts/TODO
toilet-fonts: /usr/share/doc/toilet-fonts/NEWS.gz
toilet-fonts: /usr/share/doc/toilet-fonts/README
toilet: /usr/share/doc/toilet/README
toilet: /usr/share/doc/toilet/NEWS.gz
zsh-common: /usr/share/zsh/functions/Completion/Unix/_toilet
gimp-data: /usr/share/gimp/2.0/icons/Symbolic/scalable/apps/gimp-toilet-paper.svg
toilet: /usr/share/doc/toilet/changelog.gz
toilet-fonts: /usr/share/doc/toilet-fonts/changelog.gz
toilet: /usr/bin/toilet
toilet: /usr/share/doc/toilet/copyright
toilet: /usr/share/doc/toilet/changelog.Debian.gz
gimp-data: /usr/share/gimp/2.0/icons/Legacy/24x24/apps/gimp-toilet-paper.png
gimp-data: /usr/share/gimp/2.0/icons/Symbolic-Inverted/scalable/apps/gimp-toilet-paper.svg
toilet-fonts: /usr/share/doc/toilet-fonts/changelog.Debian.gz
toilet: /usr/share/man/man1/figlet-toilet.1.gz
toilet: /usr/bin/figlet-toilet
gimp-data: /usr/share/gimp/2.0/icons/Legacy/16x16/apps/gimp-toilet-paper.png
toilet: /usr/share/man/man1/toilet.1.gz
toilet-fonts: /usr/share/doc/toilet-fonts
toilet: /usr/share/doc/toilet/TODO
toilet-fonts: /usr/share/doc/toilet-fonts/copyright
```

`pkg file /usr/share/doc/toilet`

```txt
toilet: /usr/share/doc/toilet
```

## Installation

