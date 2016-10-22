# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omnihooks-sendgrid-parse/version'

Gem::Specification.new do |spec|
  spec.name          = "omnihooks-sendgrid-parse"
  spec.version       = Omnihooks::SendgridParse::VERSION
  spec.authors       = ["Karl Falconer"]
  spec.email         = ["karl@getdropstream.com"]

  spec.summary       = %q{Omnihooks Strategy for Sendgrid Parse API Webhooks}
  spec.description   = %q{Omnihooks Strategy for Sendgrid Parse API Webhooks}
  spec.homepage      = "https://github.com/dropstream/omnihooks-sendgrid-parse"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'omnihooks', '~> 0.0.2'
  spec.add_dependency 'mail', '~>2.0', '>= 2.0.3'
  
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
