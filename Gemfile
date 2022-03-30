source 'https://rubygems.org'

gemspec

# Ronin dependencies:
gem 'ronin-core', '~> 0.1', github: "ronin-rb/ronin-core",
                            branch: 'main'

# gem 'command_kit', '~> 0.2', github: 'postmodern/command_kit.rb',
#                              branch: 'main'

gem 'jruby-openssl',	'~> 0.7', platforms: :jruby

group :development do
  gem 'rake'
  gem 'rubygems-tasks',  '~> 0.1'
  gem 'rspec',           '~> 3.0'
  gem 'simplecov',       '~> 0.20'

  gem 'kramdown',        '~> 2.0'
  gem 'kramdown-man',    '~> 0.1'

  gem 'redcarpet',       platform: :mri
  gem 'yard',            '~> 0.9'
  gem 'yard-spellcheck', require: false

  gem 'dead_end',        require: false
end
