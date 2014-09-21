# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mindtrick/version'

Gem::Specification.new do |spec|
  spec.name          = "Mindtrick"
  spec.version       = Mindtrick::VERSION
  spec.authors       = ["Josh Lewis"]
  spec.email         = ["josh.w.lewis@gmail.com"]
  spec.summary       = %q{Search completion suggestions using Redis's sorted sets.}
  spec.description   = %q{Search completion suggestions using Redis's sorted sets.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^test/})
  spec.require_paths = ["lib"]

  spec.add_dependency             'redis',    '~> 3.0'

  spec.add_development_dependency 'bundler',  '~> 1.6'
  spec.add_development_dependency 'rake',     '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
end
