require 'rails/railtie'

require 'frails/helper'
require 'frails/dev_server_proxy'

class Frails::Engine < ::Rails::Engine
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
