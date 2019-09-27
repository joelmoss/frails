# frozen_string_literal: true

require_relative 'boot'

require 'rails'
require 'active_model/railtie'
require 'action_controller/railtie'
require 'action_view/railtie'
require 'rails/test_unit/railtie'

Bundler.require(*Rails.groups)
require 'frails'

module Dummy
  class Application < Rails::Application
    config.load_defaults 6.0
    config.secret_key_base = 'abcdef'
  end
end
