# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'rails'
require 'rails/test_help'

require_relative 'test_app/config/environment'

Rails.env = 'production'

Frails.instance = ::Frails::Instance.new

class Frails::Test < Minitest::Test
  private

    def reloaded_config
      Frails.instance.instance_variable_set(:@dev_server, nil)
      Frails.dev_server
    end

    def with_rails_env(env)
      original = Rails.env
      Rails.env = ActiveSupport::StringInquirer.new(env)
      reloaded_config
      yield
    ensure
      Rails.env = ActiveSupport::StringInquirer.new(original)
      reloaded_config
    end
end
