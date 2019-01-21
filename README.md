homebrew-octave-app-openblas
============================

This [Homebrew](https://brew.sh) tap provides alternatives to certain formulas
in [homebrew/core](https://github.com/Homebrew/homebrew-core) that build against
[OpenBLAS](http://www.openblas.net) instead of Apple Accelerate.

This is a fork of [dpo's original `openblas` tap](https://github.com/dpo/homebrew-openblas), created to support Octave.app development. The difference is that this fork of the tap installs all the formulae with `-openblas` qualifiers in their names, so they do not conflict with formulae from core Homebrew or [`homebrew-octave-app-bases`](https://github.com/octave-app/homebrew-octave-app-bases).

# How to use this tap

```
brew tap octave-app/octave-app-openblas
brew install octave-openblas
```

These formulae will not be linked by default, so you need to run them from `$(brew --prefix <formula>)/bin`. For example, run octave-openblas with `$(brew --prefix octave-openblas)/bin/octave`. To enble running them with shorter names, create symlinks to them in your `/usr/local/bin` directory: `ln -s $(brew --prefix octave-openblas)/bin/octave /usr/local/bin/octave-openblas`.

### Testing Octave stable against OpenBLAS

If you're an Octave hacker and want to test the next upcoming release from the "stable" branch in the Octave Mercurial repo:

```
brew tap octave-app/octave-app-openblas
brew tap octave-app/octave-app-bases
brew install octave-stable-openblas
ln -s $(brew --prefix octave-stable-openblas)/bin/octave /usr/local/bin/octave-stable-openblas
octave-stable-openblas
```