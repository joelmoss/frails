# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module TemplateRenderer
        if Rails::VERSION::MAJOR >= 6

          # Defines 'active_template` for use in determining the `active_template` that is rendered.
          def render_template(view, template, layout_name, locals)
            return super if !view.controller || !view.controller.respond_to?(:active_template)

            view.controller.active_template = template if view.controller.active_template.nil?

            result = super

            view.controller.active_template = nil if view.controller

            result
          end

        else

          # Defines 'active_template` for use in determining the `active_template` that is rendered.
          def render_template(template, layout_name = nil, locals = {})
            return super if !@view.controller || !@view.controller.respond_to?(:active_template)

            @view.controller.active_template = template if @view.controller.active_template.nil?

            result = super

            @view.controller.active_template = nil if @view.controller

            result
          end

        end
      end
    end
  end
end