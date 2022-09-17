# ronin-repos-install 1 "2022-01-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos install` [*options*] *URI*

## DESCRIPTION

Downloads a repository.

## ARGUMENTS

*URI*
	The URI to the git repository.

## OPTIONS

`-h`, `--help`
  Prints help information.

## FILES

*~/.cache/ronin-repos/*
	Installation directory for all repositories.

## ENVIRONMENT

HOME
	Specifies the home directory of the user. Ronin will search for the
	*~/.cache/ronin-repos* cache directory within the home directory.

XDG_CACHE_HOME
  Specifies the cache directory to use. Defaults to *$HOME/.cache*.

## EXAMPLES

`ronin-repos install https://github.com/user/repo.git`
	Installs a public repository over HTTPS.

`ronin-repos install git@example.com:/home/secret/repo`
	Installs a private repository over SSH.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-repos(1) ronin-repos-list(1) ronin-repos-remove(1) ronin-repos-update(1) ronin-repos-purge(1)
