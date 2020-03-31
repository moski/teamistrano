# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teamistrano/version'

Gem::Specification.new do |gem|
  gem.name          = "teamistrano"
  gem.version       = Teamistrano::VERSION
  gem.authors       = ["Moski"]
  gem.email         = ["moski.doski@gmail.com"]
  gem.description   = %q{Send notifications to MS Teams about Capistrano deployments.}
  gem.summary       = %q{Send notifications to MS Teams about Capistrano deployments.}
  gem.homepage      = "https://github.com/moski/teamistrano"
  gem.license       = 'MIT'

  gem.required_ruby_version = '>= 2.0.0'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'capistrano', '>= 3.8.1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'pry'
end
