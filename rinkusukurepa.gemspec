# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rinkusukurepa/version'

Gem::Specification.new do |spec|
  spec.name          = "rinkusukurepa"
  spec.version       = Rinkusukurepa::VERSION
  spec.authors       = ["rewin0087"]
  spec.email         = ["erwin_rulezzz87@yahoo.com"]

  spec.summary       = %q{A library for Scraping a webpage by it's url and return the web page title, description, site name, images, favicon and video (if there's a video). Inspired by facebook url sharer.}
  spec.description   = %q{A library for Scraping a webpage by it's url and return the web page title, description, site name, images, favicon and video (if there's a video). Inspired by facebook url sharer. }
  spec.homepage      = "https://github.com/rewin0087/rinkusukurepa"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_runtime_dependency "nokogiri", "~> 1.6.7"
  spec.add_runtime_dependency "open_uri_redirections", "~> 0.2.1"
  spec.add_runtime_dependency "fastimage", "~> 1.8.1"
end
