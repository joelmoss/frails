# frozen_string_literal: true

require_relative 'lib/frails/version'

Gem::Specification.new do |spec|
  spec.name          = 'frails'
  spec.version       = Frails::VERSION
  spec.authors       = ['Joel Moss']
  spec.email         = ['joel@developwithstyle.com']

  spec.summary       = 'A Modern [F]ront End on [Rails] and Webpack'
  spec.homepage      = 'https://github.com/joelmoss/frails'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 6.0', '< 6.1'
  spec.add_dependency 'nokogiri', '>= 1.10.4'
  spec.add_dependency 'rack-proxy', '>= 0.6.5'
end
