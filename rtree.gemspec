# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtree/version'

Gem::Specification.new do |spec|
  spec.name          = "rtree"
  spec.version       = Rtree::VERSION
  spec.authors       = ["Andrew Newman"]
  spec.email         = ["andrew.newman@sdx.com.au"]
  spec.description   = %q{A set of implementations of different types of RTree}
  spec.summary       = %q{Implementation of original RTree data structure as well as others}
  spec.homepage      = ""
  spec.license       = "Apache License Version 2.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
