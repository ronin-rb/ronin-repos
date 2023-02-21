# ronin-repos-update 1 "2023-02-01" Ronin Repos "User Manuals"

## SYNOPSIS

`ronin-repos update` [*options*] [*REPO*]

## DESCRIPTION

Updates all repositories or just one.

## ARGUMENTS

*REPO*
	The optional repository name to only update.

## OPTIONS

`-h`, `--help`
  Prints help information.

## EXAMPLES

`ronin-repos update`
  Updates all installed repositories.

`ronin update repo`
	Updates the specific repository named `repo`.

## ENVIRONMENT

*HOME*
	Specifies the home directory of the user. Ronin will search for the
	`~/.cache/ronin-repos` cache directory within the home directory.

*XDG_CACHE_HOME*
  Specifies the cache directory to use. Defaults to `$HOME/.cache`.

## FILES

`~/.cache/ronin-repos/`
	Installation directory for all repositories.

## AUTHOR

Postmodern <postmodern.mod3@gmail.com>

## SEE ALSO

ronin-repos(1) ronin-repos-repos-install(1) ronin-repos-list(1) ronin-repos-remove(1) ronin-repos-purge(1)
