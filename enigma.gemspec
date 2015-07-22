# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enigma/version'

Gem::Specification.new do |spec|
  spec.name          = "enigma"
  spec.version       = Enigma::VERSION
  spec.authors       = ["Tiago Mendes-Costa"]
  spec.email         = ["tiago@mendes-costa.net"]

  spec.summary       = %q{A Ruby implementation of the Enigma machine.}
  spec.homepage      = "https://github.com/otagi/enigma"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
