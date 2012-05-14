# -*- encoding: utf-8 -*-
require File.expand_path('../lib/php-serial/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Jorge Urias"]
  gem.email         = ["jurias@gmail.com"]
  gem.description   = %q{PHP serialization/unserialization with session support}
  gem.summary       = %q{PHP serialization/unserialization with session support}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "php-serial"
  gem.require_paths = ["lib"]
  gem.version       = Php::Serial::VERSION
end
