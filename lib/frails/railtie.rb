# frozen_string_literal: true

require 'rails/railtie'
require 'English'
require 'frails/helper'
require 'frails/dev_server_proxy'

class Frails::Engine < ::Rails::Engine
  initializer 'frails.proxy' do |app|
    app.middleware.insert_before 0, Frails::DevServerProxy, ssl_verify_none: true
  end

  initializer 'frails.yarn_check' do
    if Rails.env.development? && File.exist?('yarn.lock')
      output = `yarn check --integrity && yarn check --verify-tree 2>&1`

      unless $CHILD_STATUS.success?
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

  initializer 'frails.rendering' do |_conf|
    ActiveSupport.on_load :action_controller do
      ActionController::Base.prepend_view_path Rails.root.join('app', 'components')
    end

    ActiveSupport.on_load :action_view do
      require 'frails/monkey/action_view/abstract_renderer'
      require 'frails/monkey/action_view/template_renderer'
      require 'frails/monkey/action_view/partial_renderer'
      require 'frails/monkey/action_view/renderer'

      ActionView::AbstractRenderer.send :prepend, Frails::Monkey::ActionView::AbstractRenderer
      ActionView::TemplateRenderer.send :prepend, Frails::Monkey::ActionView::TemplateRenderer
      ActionView::PartialRenderer.send :prepend, Frails::Monkey::ActionView::PartialRenderer
      ActionView::Renderer.send :prepend, Frails::Monkey::ActionView::Renderer
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
