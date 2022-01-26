# ronin-repos 1 "2022-01-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos` [*options*] [*COMMAND*]

## DESCRIPTION

Allows downloading and managing git repositories. `ronin-repos` can install
and use any git repository containing Ruby code or other data.

## FILES

*~/.cache/ronin-repos*
	Installation directory for repositories.

## ENVIRONMENT

HOME
	Specifies the home directory of the user. Ronin will search for the
	*~/.cache/ronin-repos* cache directory within the home directory.

XDG_CACHE_HOME
  Specifies the cache directory to use. Defaults to *$HOME/.cache*.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-repos-install(1) ronin-repos-list(1) ronin-repos-remove(1) ronin-repos-update(1) ronin-repos-purge(1)
