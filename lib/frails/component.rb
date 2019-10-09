# frozen_string_literal: true

module Frails::Component
end

module ActionView
  extend ActiveSupport::Autoload

  # Make sure ActionView::SyntaxErrorInTemplate is loaded.
  eager_autoload do
    autoload_at 'action_view/template/error' do
      autoload :SyntaxErrorInTemplate
    end
  end
end

require 'frails/component/renderer_concerns'
require 'frails/component/renderer'
require 'frails/component/react_renderer'
require 'frails/component/abstract_component'
require 'frails/component/base'
require 'frails/component/react_component'
