require 'rails/railtie'

require 'frails/helper'
require 'frails/dev_server_proxy'

class Frails::Engine < ::Rails::Engine
  # Allows Webpacker config values to be set via Rails env config files
  config.frails = ActiveSupport::OrderedOptions.new

  initializer 'frails.default_config' do |app|
    assign_config app, :public_output_path, '/assets'
    assign_config app, :dev_server_port, 8080
    assign_config app, :dev_server_host, 'localhost'
  end

  initializer 'frails.proxy' do |app|
    app.middleware.insert_before 0, Frails::DevServerProxy, ssl_verify_none: true
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

def assign_config(app, name, default_value)
  app.config.frails[name] = app.config.frails.fetch(name, default_value)
end