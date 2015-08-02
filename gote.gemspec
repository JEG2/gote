# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gote/version'

Gem::Specification.new do |spec|
  spec.name          = "gote"
  spec.version       = Gote::VERSION
  spec.authors       = ["James Edward Gray II"]
  spec.email         = ["james@graysoftinc.com"]

  spec.summary       = %q{Gote is the creature you feed your notes to.}
  spec.description   = <<END_DESCRIPTION
Gote is a super minimal Evernote-like tool for command-line fans.  It's mainly
just a marriage of plain text (defaulting to Markdown), the `EDITOR` variable,
and Git.
END_DESCRIPTION
  spec.homepage      = "https://github.com/JEG2/gote"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake",    "~> 10.4"
  spec.add_development_dependency "rspec",   "~> 3.3"
  spec.add_development_dependency "rerun",   "~> 0.10"
end
