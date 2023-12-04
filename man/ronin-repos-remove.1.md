# ronin-repos-remove 1 "2023-02-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos remove` [*options*] *REPO*

## DESCRIPTION

Removes a repository.

## ARGUMENTS

*REPO*
: The name of the repository to remove.

## OPTIONS

`-h`, `--help`
: Prints help information.

## EXAMPLES

`ronin-repo remove repo`
: Removes the repository with with the name `repo`.

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