# frozen_string_literal: true

require 'rails/railtie'

require 'frails/helper'
require 'frails/dev_server_proxy'

class Frails::Engine < ::Rails::Engine
  initializer 'frails.proxy' do |app|
    app.middleware.insert_before 0, Frails::DevServerProxy, ssl_verify_none: true
  end

  # ================================
  # Check Yarn Integrity Initializer
  # ================================
  #
  # development (on by default):
  #
  #    to turn off:
  #     - edit config/environments/development.rb
  #     - add `config.webpacker.check_yarn_integrity = false`
  #
  # production (off by default):
  #
  #    to turn on:
  #     - edit config/environments/production.rb
  #     - add `config.webpacker.check_yarn_integrity = true`
  initializer 'frails.yarn_check' do
    if File.exist?('yarn.lock')
      output = `yarn check --integrity && yarn check --verify-tree 2>&1`

      unless $?.success?
        warn "\n\n"
        warn '========================================'
        warn '  Your Yarn packages are out of date!'
        warn '  Please run `yarn install --check-files` to update.'
        warn '========================================'
        warn "\n\n"
        warn output
        warn "\n\n"

        exit(1)
      end
    end
  end

  initializer 'frails.view_context' do
    ActiveSupport.on_load :action_controller do
      require 'frails/monkey/action_controller/view_context'
      ActionController::Base.send :prepend, Frails::Monkey::ActionController::ViewContext
    end

    ActiveSupport.on_load :action_view do
      require 'frails/monkey/action_view/template_renderer'
      ActionView::TemplateRenderer.send :prepend, Frails::Monkey::ActionView::TemplateRenderer
    end
  end

  initializer 'frails.helper' do
    ActiveSupport.on_load :action_controller do
      ActionController::Base.helper Frails::Helper
    end

    ActiveSupport.on_load :action_view do
      include Frails::Helper
    end
  end
end
