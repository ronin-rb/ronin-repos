### 0.2.0 / 2024-XX-XX

* Added {Ronin::Repos::Repository#url}.
* Added {Ronin::Repos::Repository#last_updated_at}.
* Added {Ronin::Repos.cache_dir}.

#### CLI

* Added the `ronin-repos show` command.
* Changed `ronin-repos list` to fuzzy match repo names.
* Changed `ronin-repos new` to also create empty `exploits/`, `payloads/`,
  `recon/`, and `brute/`.
* Added the `ronin-repos completion` command to install shell completion files
  for all `ronin-repos` commands for Bash and Zsh shells.

### 0.1.1 / 2023-06-09

* Fixed a bug in {Ronin::Repos::ClassDir::ClassMethods#list_files} where the
  {Ronin::Repos::ClassDir::ClassMethods#repo_class_dir repo_class_dir} was not
  being removed from paths.
* Documentation fixes and improvements.

#### CLI

* Multiple bug fixes to the `ronin-repos install` command.
* Add missing man-page for the `ronin-repos new` command.

### 0.1.0 / 2023-02-01

* Initial release:
  * Supports installing any [Git][git] repository.
  * Manages installed repositories.

[git]: https://git-scm.com/
