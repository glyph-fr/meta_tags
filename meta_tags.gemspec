$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "meta_tags/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "meta_tags"
  s.version     = MetaTags::VERSION
  s.authors     = ["Valentin Ballestrino, Damien Corticchiato"]
  s.email       = ["vala@glyph.fr"]
  s.homepage    = "http://glyph.fr"
  s.summary     = "Simple gem to handle basical title, meta tags and og: tags"
  s.description = "Simple gem to handle basical title, meta tags and og: tags"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.11"

  s.add_development_dependency "sqlite3"
end