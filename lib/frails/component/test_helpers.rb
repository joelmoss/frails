# frozen_string_literal: true

module Frails
  module Component
    module TestHelpers
      def render_inline(component, **args, &block)
        Nokogiri::HTML(controller.view_context.render({ component: component }, args, &block))
      end

      def controller
        @controller ||= ApplicationController.new.tap { |c| c.request = request }
      end

      def request
        @request ||= ActionDispatch::TestRequest.create
      end
    end
  end
end
