# ronin-repos-remove 1 "2022-01-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos remove` [*options*] *REPO*

## DESCRIPTION

Removes a repository.

## ARGUMENTS

*REPO*
	The name of the repository to remove.

## OPTIONS

## EXAMPLES

`ronin-repo remove repo`
	Removes the repository with with the name `repo`.

## FILES

*~/.cache/ronin-repos/*
	Installation directory for all repositories.

## ENVIRONMENT

HOME
	Specifies the home directory of the user. Ronin will search for the
	*~/.cache/ronin-repos* cache directory within the home directory.

XDG_CACHE_HOME
  Specifies the cache directory to use. Defaults to *$HOME/.cache*.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-repos(1), ronin-repos-install(1) ronin-repos-list(1) ronin-repos-update(1) ronin-repos-purge(1)
