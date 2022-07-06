# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bcloud-registry/version'

Gem::Specification.new do |spec|
  spec.name          = "bcloud-registry"
  spec.version       = BcloudPlugins::Registry::VERSION
  spec.authors       = ["Artem Polunin"]

  spec.summary       = %q{A BCloud plugin to allow integration with private box registries.}
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/devbens/bcloud-registry-plugin"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ruby-progressbar"
  spec.add_dependency "rest-client", ['>= 1.6.0', '< 3.0']

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 2.14.0"
  spec.add_development_dependency "webmock", "~> 2.1.0"
  spec.add_development_dependency "simplecov"
end
