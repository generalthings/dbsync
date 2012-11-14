# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "dbsync/version"

Gem::Specification.new do |gem|
  gem.name        = "dbsync"
  gem.version     = Dbsync::VERSION
  gem.authors     = ["Bryan Ricker"]
  gem.email       = ["bricker88@gmail.com"]
  gem.description = %q{A set of rake tasks to help you sync your remote production data with your local database for development.}
  gem.summary     = %q{Easy syncing from remote to development database in Rails.}
  gem.homepage    = "http://github.com/bricker88/dbsync"

  gem.rubyforge_project = "dbsync"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib", "lib/tasks"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  gem.add_runtime_dependency "activesupport", "~> 3.2.8"
  gem.add_runtime_dependency "activerecord", "~> 3.2.8"
  gem.add_runtime_dependency "railties", "~> 3.2.8"
  
  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
end
