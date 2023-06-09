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
