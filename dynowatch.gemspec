# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dynowatch/version'

Gem::Specification.new do |spec|
  spec.name          = "dynowatch"
  spec.version       = Dynowatch::VERSION
  spec.authors       = ["gnerkus"]
  spec.email         = ["ifeanyioraelosi@gmail.com"]

  spec.summary       = %q{A dyno analysis tool for Heroku's HTTP log drains}
  spec.homepage      = "https://github.com/gnerkus/dynowatch"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = ["dynowatch"]
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
