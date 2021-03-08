# ronin-repos

[![CI](https://github.com/ronin-rb/ronin-repos/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-repos/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-repos.svg)](https://codeclimate.com/github/ronin-rb/ronin-repos)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin-repos)
* [Issues](https://github.com/ronin-rb/ronin-repos/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-repos/frames)
* [Slack](https://ronin-rb.slack.com) |
  [Discord](https://discord.gg/6WAb3PsVX9) |
  [Twitter](https://twitter.com/ronin_rb) |
  [IRC](https://ronin-rb.dev/irc/)

## Description

Allows installing and managing 3rd-party repositories of scripts, code,
or data for ronin.

## Features

* Supports installing/updating/uninstalling of Repositories.
  * Supports installing Repositories from various media types:
    * [Subversion (SVN)][svn]
    * [Mercurial (Hg)][hg]
    * [Git][git]
    * Rsync
* Caches exploits, payloads, scanners, etc stored within Repositories
  into the Database.

## Synopsis

Install a Repository:

    $ ronin install svn://example.com/path/to/repo

List installed Repositories:

    $ ronin repos

Update all installed Repositories:

    $ ronin update

Update a specific Repositories:

    $ ronin update repo-name

Uninstall a specific Repositories:

    $ ronin uninstall repo-name

## Requirements

* [Ruby] >= 1.9.1
* [data_paths] ~> 0.3
* [pullr] ~> 0.1, >= 0.1.2

## Install

    $ gem install ronin-repos

### Gemfile

    gem 'ronin-repos', '~> 0.1'

## Development

1. [Fork It!](https://github.com/ronin-rb/ronin-repos/fork)
2. Clone It!
3. `cd ronin-repos`
4. `bundle install`
5. `git checkout -b my_feature`
6. Code It!
7. `bundle exec rake spec`
8. `git push origin my_feature`

## License

Copyright (c) 2006-2021 Hal Brodigan (postmodern.mod3 at gmail.com)

This file is part of ronin-repos.

Ronin is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Ronin is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Ronin.  If not, see <https://www.gnu.org/licenses/>.

[Ruby]: https://www.ruby-lang.org
[Repositories]: https://github.com/ronin-rb/example-repo

[svn]: https://subversion.apache.org/
[hg]: https://www.mercurial-scm.org/
[git]: https://git-scm.com/

[data_paths]: https://github.com/postmodern/data_paths#readme
[pullr]: https://github.com/postmodern/pullr#readme
