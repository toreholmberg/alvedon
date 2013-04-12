# -*- encoding: utf-8 -*-
require File.expand_path('../lib/alvedon/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["Tore Holmberg"]
  gem.email = ["tore.holmberg@gmail.com"]
  gem.description = %q{Simple web assets build tool using Sprockets}
  gem.summary = %q{Qucikly build web assets in any Ruby environment}
  gem.homepage = "http://github.com/toreholmberg/alvedon"

  gem.files = `git ls-files`.split($\)
  gem.executables  = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name  = "alvedon"
  gem.require_paths = ["lib"]
  gem.version = Alvedon::VERSION

  gem.add_dependency 'thor'
  gem.add_dependency 'listen'
  gem.add_dependency 'rb-fsevent'
  gem.add_dependency 'sprockets'
  gem.add_dependency 'sprockets-sass'
  gem.add_dependency 'sprockets-commonjs'
  gem.add_dependency 'haml_coffee_assets'
  gem.add_dependency 'coffee-script'
  gem.add_dependency 'sass'
  gem.add_dependency 'compass'
  gem.add_dependency 'uglifier'
  gem.add_dependency 'yui-compressor'

end