# ronin-repos-purge 1 "2023-02-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos purge` [*options*]

## DESCRIPTION

Removes all installed repositories.

## OPTIONS

`-C`, `--cache-dir` *DIR*
: Overrides the default cache directory.

`-h`, `--help`
: Prints help information.

## EXAMPLES

`ronin-repo purge`
: Removes all installed repositories.

## ENVIRONMENT

*HOME*
: Specifies the home directory of the user. Ronin will search for the
  `~/.cache/ronin-repos` cache directory within the home directory.

*XDG_CACHE_HOME*
: Specifies the cache directory to use. Defaults to `$HOME/.cache`.

## FILES

`~/.cache/ronin-repos/`
: Installation directory for all repositories.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

[ronin-repos](ronin-repos.1.md) [ronin-repos-install](ronin-repos-install.1.md) [ronin-repos-list](ronin-repos-list.1.md) [ronin-repos-update](ronin-repos-update.1.md) [ronin-repos-purge](ronin-repos-purge.1.md)