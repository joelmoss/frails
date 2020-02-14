# frozen_string_literal: true

module Frails
  module Component
    module TestHelpers
      def render_inline(options = {}, locals = {}, &block)
        Nokogiri::HTML(controller.view_context.render(options, locals, &block))
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
