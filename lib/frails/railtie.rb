# frozen_string_literal: true

require 'rails'
require 'frails/helper'
require 'frails/dev_server_proxy'

class Frails::Engine < ::Rails::Engine
  initializer 'frails.proxy' do |app|
    app.middleware.insert_before 0, Frails::DevServerProxy, ssl_verify_none: true
  end

  initializer 'frails' do
    ActiveSupport.on_load :action_controller do
      require 'frails/side_load_assets'

      include Frails::SideLoadAssets
    end

    ActiveSupport.on_load :action_mailer do
      require 'frails/side_load_assets'

      include Frails::SideLoadAssets
    end

    ActiveSupport.on_load :action_view do
      require 'frails/monkey/action_view/abstract_renderer'
      require 'frails/monkey/action_view/template_renderer'
      require 'frails/monkey/action_view/partial_renderer'
      require 'frails/monkey/action_view/renderer'

      ActionView::AbstractRenderer.prepend Frails::Monkey::ActionView::AbstractRenderer
      ActionView::TemplateRenderer.prepend Frails::Monkey::ActionView::TemplateRenderer
      ActionView::PartialRenderer.prepend Frails::Monkey::ActionView::PartialRenderer
      ActionView::Renderer.prepend Frails::Monkey::ActionView::Renderer

      include Frails::Helper
    end
  end
end
