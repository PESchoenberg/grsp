# grsp - Useful Scheme functions.

[![DOI](https://zenodo.org/badge/163432499.svg)](https://zenodo.org/badge/latestdoi/163432499)


## Overview:

Some useful functions for GNU Guile Scheme programs.


## Dependencies:

* GNU Guile - v2.2.3 or later ( https://www.gnu.org/software/guile/ ). N.B. I am
currently using v3.0 and plan to put it as a minimum req in the next published
version.

* Sqlp - Latest version available ( https://peschoenberg.github.io/sqlp/ )


## Installation:

* Assuming you already have GNU Guile running on your system, get grsp, unpack it
into a folder of your choice and cd into it.

* grsp installs as a GNU Guile library. See GNU Guile's manual instructions for
details concerning your OS and distribution, but as an example, on Ubuntu you
would issue, given that [version] represents the version of your GNU Guile
installation (for example, 2.2 or 3.0):

      sudo mkdir /usr/share/guile/site/[version]/grsp

      or

      sudo cp *.scm -rv /usr/share/guile/site/[version]/grsp

      or

      sudo cp *.scm -rv /usr/local/share/guile/site/[version]/grsp

and that will do the trick.


## Uninstall:

* You just need to remove /usr/share/guile/site/]version]/grsp and its subfolders.

* There are no other dependencies.


## Usage:

* Should be used as any other GNU Guile library; programs using grsp should be 
written and compiled as any regular Guile program.

* See the examples contained in the /examples folder. These are self-explaining
and filled with comments.


## Credits and Sources:

* GNU contributors (2019). GNU's programming and extension language — GNU Guile.
[online] Gnu.org. Available at: https://www.gnu.org/software/guile/
[Accessed 2 Sep. 2019].

* URL of this project - https://github.com/PESchoenberg/grsp.git

Please let me know if I forgot to add any credits or sources.


## License:

* LGPL-3.0-or-later.


