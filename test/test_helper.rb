# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

ENV['RAILS_ENV'] = 'development'

require 'bundler/setup'
require 'combustion'
require 'minitest/autorun'
require 'mocha/minitest'
require 'frails/component/test_helpers'

Combustion.path = 'test/dummy'
Combustion.initialize! :action_controller, :action_view do
  config.hosts << 'www.example.com'
end

# Quiet down logging.
Frails.logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT))
Frails.logger.level = Logger::WARN
