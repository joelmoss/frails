# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module RenderHelper
        def render(options = {}, args = {}, &block)
          if options.is_a?(Class) && options < Frails::Component::Base
            options.new(args).render_in(self, &block)
          elsif options.is_a?(Hash) && options.key?(:component)
            component = component_class(options.delete(:component))
            component.new(options[:locals]).render_in(self, &block)
          else
            super
          end
        end

        private

          def component_class(name)
            return name if name.is_a?(Class)

            display_name = name.to_s.camelcase
            klass = "#{display_name}Component"

            unless Rails.root.join('app', 'components', name.to_s).exist?
              raise NotImplementedError, "Could not find a component for #{display_name}."
            end

            if Object.const_defined?(klass, false)
              klass.constantize
            else
              Object.const_set klass, Class.new(Frails::Component::Base)
            end
          end
      end
    end
  end
end
