# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rubocop_lineup/version"

Gem::Specification.new do |spec|
  spec.name          = "rubocop_lineup"
  spec.version       = RubocopLineup::VERSION
  spec.authors       = ["chrismo"]
  spec.email         = ["chrismo@clabs.org"]

  spec.summary       = "Rubocop plugin to restrict cops to only changed lines."
  spec.homepage      = "https://github.com/mysterysci/rubocop_lineup"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = "~> 2.1"

  spec.add_dependency "git", "~> 1.3"
  spec.add_dependency "rubocop", "~> 0.46"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
