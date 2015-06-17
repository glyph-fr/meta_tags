$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'meta_tags/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'meta_tags'
  s.version     = MetaTags::VERSION
  s.authors     = ['Valentin Ballestrino', 'Damien Corticchiato']
  s.email       = ['vala@glyph.fr']
  s.homepage    = 'https://github.com/glyph-fr/meta_tags'
  s.summary     = 'HTML meta tags management for Rails'
  s.description = "HTML meta tags management for Rails with support for Facebook's OpenGraph tags and Twitter cards"

  s.files = Dir['{app,config,db,lib}/**/*'] + ['MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'sanitize'
  s.add_dependency 'truncate_html'

  s.add_development_dependency 'sqlite3'
end
