# ronin-repos

[![CI](https://github.com/ronin-rb/ronin-repos/actions/workflows/ruby.yml/badge.svg)](https://github.com/ronin-rb/ronin-repos/actions/workflows/ruby.yml)
[![Code Climate](https://codeclimate.com/github/ronin-rb/ronin-repos.svg)](https://codeclimate.com/github/ronin-rb/ronin-repos)
[![Gem Version](https://badge.fury.io/rb/ronin-repos.svg)](https://badge.fury.io/rb/ronin-repos)

* [Website](https://ronin-rb.dev)
* [Source](https://github.com/ronin-rb/ronin-repos)
* [Issues](https://github.com/ronin-rb/ronin-repos/issues)
* [Documentation](https://ronin-rb.dev/docs/ronin-repos/frames)
* [Discord](https://discord.gg/6WAb3PsVX9) |
  [Mastodon](https://infosec.exchange/@ronin_rb)

## Description

ronin-repos provides a repository system for installing, managing, and accessing
third-party git repositories, that can contain additional Ruby code or other
data.

Third-party git repositories can be used to extend parts of Ronin. Other Ronin
libraries can then list and load additional third-party Ruby classes from
specific directories within the installed third-party repos:

* `exploits/` - may contain additional exploits for [ronin-exploits].
* `payloads/` - may contain additional payloads for [ronin-payloads].

**tl;dr** ronin-repos is essentially a decentralized plugin system for Ronin
using git repos.

ronin-repos is part of the [ronin-rb] project, a toolkit for security research
and development.

## Features

* Supports installing any [Git][git] repository.
* Manages installed repositories.
* Has 85% documentation coverage.
* Has 100% test coverage.

## Synopsis

```
Usage: ronin-repos [options] [COMMAND [ARGS...]]

Options:
    -h, --help                       Print help information

Arguments:
    [COMMAND]                        The command name to run
    [ARGS ...]                       Additional arguments for the command

Commands:
    completion
    help
    install
    list, ls
    new
    purge
    remove, rm
    show, info
    update, up
```

Install a repository:

```shell
$ ronin-repos install https://github.com/...
```

List installed Repositories:

```shell
$ ronin-repos ls
```

Update all installed Repositories:

```shell
$ ronin-repos update
```

Update a specific Repositories:

```shell
$ ronin-repos update NAME
```

Uninstall a specific Repositories:

```shell
$ ronin-repos rm repo-name
```

Delete all repositories:

```shell
$ ronin-repos purge
```

Generate your own repo:

```shell
$ ronin-repos new my-repo
$ git remote add origin git@github.com:user/my-repo.git
$ git push -u origin main
```

## Examples

```ruby
require 'ronin/repos'

Ronin::Repos.find_file('wordlists/wordlist.txt')
# => "/home/user/.cache/ronin-repos/foo-repo/wordlists/wordlist.txt"

Rnnin::Repos.glob("wordlists/*.txt")
# => ["/home/user/.cache/ronin-repos/foo-repo/wordlists/cities.txt",
#     "/home/user/.cache/ronin-repos/foo-repo/wordlists/states.txt",
#     "/home/user/.cache/ronin-repos/bar-repo/wordlists/bands.txt",
#     "/home/user/.cache/ronin-repos/bar-repo/wordlists/beers.txt"]
```

## Requirements

* [Ruby] >= 3.0.0
* [ronin-core] ~> 0.2

## Install

```shell
$ gem install ronin-repos
```

### Gemfile

```ruby
gem 'ronin-repos', '~> 0.1'
```

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

Copyright (c) 2021-2024 Hal Brodigan (postmodern.mod3 at gmail.com)

ronin-repos is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published
by the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

ronin-repos is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with ronin-repos.  If not, see <https://www.gnu.org/licenses/>.

[ronin-rb]: https://ronin-rb.dev/

[Ruby]: https://www.ruby-lang.org
[git]: https://git-scm.com/
[ronin-core]: https://github.com/ronin-rb/ronin-core#readme
[ronin-exploits]: https://github.com/ronin-rb/ronin-exploits#readme
[ronin-payloads]: https://github.com/ronin-rb/ronin-payloads#readme
