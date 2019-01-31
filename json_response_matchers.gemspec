
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "json_response_matchers/version"

Gem::Specification.new do |spec|
  spec.name          = "json_response_matchers"
  spec.version       = JsonResponseMatchers::VERSION
  spec.authors       = ["Szijjártó Nagy Misu"]
  spec.email         = ["szijjartonagy.misu@gmail.com"]

  spec.summary       = 'rspec matchers to test http responses with json content in rails'
  spec.description   = 'Provides two matchers (#have_json_content and #have_json_values) to make testing the content of json responses easy.'
  spec.homepage      = 'https://github.com/SzNagyMisu/json_response_matchers'
  spec.license       = "MIT"

  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"]    = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -- lib/*`.split("\n") + %w[ README.md LICENSE.txt json_response_matchers.gemspec ]
  spec.bindir        = "bin"
  spec.test_files    = `git ls-files -- gemfiles/* spec/*`.split("\n") + %w[ Appraisals Gemfile Rakefile .rspec bin/test ]
  spec.executables   = []
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_dependency "rspec", "~> 3.0"
  spec.add_dependency "activesupport", ">= 4.0.6"

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "appraisal", "~> 2.2"
end
