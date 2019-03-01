# grsp - Useful Scheme functions.

[![DOI](https://zenodo.org/badge/163432499.svg)](https://zenodo.org/badge/latestdoi/163432499)


## Overview:

Some useful functions for GNU Guile Scheme programs.


## Dependencies:

* GNU Guile - ver 2.2.3 or newer ( https://www.gnu.org/software/guile/ )


## Installation:

* Assuming you already have GNU Guile running on your system, get grsp, unpack it
into a folder of your choice and cd into it.

* grsp installs as a GNU Guile library. See GNU Guile's manual instructions for
details concerning your OS and distribution, but as an example, on Ubuntu you
would issue:

      sudo mkdir /usr/share/guile/site/2.2/grsp

      sudo cp *.scm -rv /usr/share/guile/site/2.2/grsp

and that will do the trick.


## Uninstall:

* You just need to remove /usr/share/guile/site/2.2/grsp and its subfolders.

* There are no other dependencies.


## Usage:

* Should be used as any other GNU Guile library; programs using grsp should be 
written and compiled as any regular Guile program.

* See the examples contained in the /examples folder. These are self-explaining
and filled with comments.


## Credits and Sources:

* GNU Guile - https://www.gnu.org/software/guile/

* URL of this project - https://github.com/PESchoenberg/grsp.git


## License:

* LGPL-3.0-or-later.


