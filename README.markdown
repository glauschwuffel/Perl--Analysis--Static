This is the home of the Perl package Perl::Analysis::Static. Welcome!

The repository contains Perl modules and tools for static analysis of
Perl documents (which are roughly speaking all perl sources you would write
and not all perl sources that are possible).

The project is young and in alpha stage. Currently you need Dist::Zilla
to play with it. To start hacking, install that module:

  cpanm Dist::Zilla
  
Then pull sources from this repository and install the plugins needed for
building the package:

  dzil authordeps | cpanm
  
Then you may build the Perl package Perl::Analysis::Static via

  dzil build

Have fun!
