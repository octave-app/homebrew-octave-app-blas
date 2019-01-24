homebrew-octave-app-blas
========================

This [Homebrew](https://brew.sh) tap provides BLAS-related formulae beyond
what [homebrew/core](https://github.com/Homebrew/homebrew-core) provides.
This includes multiple BLAS implementations, and formulae that build against
[OpenBLAS](http://www.openblas.net) instead of Apple Accelerate.

This is a fork of [dpo's original `openblas` tap](https://github.com/dpo/homebrew-openblas). It was created to support [Octave.app](https://octave-app.org) development. The differences are:
  * This fork of the tap installs all the OpenBLAS-linked formulae with `-openblas` suffixes in their names, so they do not conflict with formulae from core Homebrew or [`homebrew-octave-app-bases`](https://github.com/octave-app/homebrew-octave-app-bases).
  * This fork provides additional BLAS implementations besides OpenBLAS

# About BLAS

BLAS is an API specification for a linear algebra library. There are multiple implementations of it available. These include:

  * [Apple Accelerate/vecLib](https://developer.apple.com/documentation/accelerate/veclib)
  * The [BLAS Reference Implementation](http://www.netlib.org/blas/) from Netlib. This is a non-optimized BLAS implementation.
  * [OpenBLAS](https://www.openblas.net/), an optimized open source BLAS implementation.
  * [ATLAS](http://math-atlas.sourceforge.net/)
  * [Intel Math Kernel Library (MKL)](https://software.intel.com/en-us/mkl)

Apple Accelerate/vecLib is provided by macOS. Homebrew core supplies an [OpenBLAS formula](https://github.com/Homebrew/homebrew-core/blob/master/Formula/openblas.rb). This tap provides formulae for ATLAS (`atlas`) and the BLAS Reference Implementation (`blas-ri`).

The Intel MKL isn't Free Software, but it _is_ free as in beer! You can [download it, use it, and redistributed it without charge](https://software.intel.com/en-us/mkl/license-faq).

In theory, software built against the BLAS API can swap out its implementation libraries at run time. This would be accomplished on macOS with the `DYLD_LIBRARY_PATH` and/or `DYLD_INSERT_LIBRARIES` environment variables if it's not directly supported by the software. (I haven't tried this yet, though.)

# How to use this tap

```
brew tap octave-app/octave-app-blas
brew install octave-openblas
brew install blas-ri atlas
```

These formulae will not be linked by default, so you need to run them from `$(brew --prefix <formula>)/bin`. For example, run octave-openblas with `$(brew --prefix octave-openblas)/bin/octave`. To enble running them with shorter names, create symlinks to them in your `/usr/local/bin` directory: `ln -s $(brew --prefix octave-openblas)/bin/octave /usr/local/bin/octave-openblas`.

To use the libraries installed by these formulae, you will need to pass additional `configure` or compiler flags pointing at the formula installations.

### Testing Octave stable against OpenBLAS

If you're an Octave hacker and want to test the next upcoming release from the "stable" branch in the Octave Mercurial repo:

```
brew tap octave-app/octave-app-blas
brew tap octave-app/octave-app-bases
brew install octave-stable-openblas
ln -s $(brew --prefix octave-stable-openblas)/bin/octave /usr/local/bin/octave-stable-openblas
octave-stable-openblas
```

Or if you want to go crazy and try the unstable "default" development code:

```
brew install octave-default-openblas
ln -s $(brew --prefix octave-default-openblas)/bin/octave /usr/local/bin/octave-default-openblas
```

_TODO: Consider providing these "octave-<branch>-openblas" commands automatically in the formulae._
