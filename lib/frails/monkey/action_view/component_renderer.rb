# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module ComponentRenderer
        def render(context, options)
          if options.key?(:partial)
            render_partial(context, options)
          elsif options.key?(:component)
            render_component(context, options)
          else
            render_template(context, options)
          end
        end

        def render_component(context, options, &block)
          component = options[:component].to_s

          if Rails.root.join('app', 'components', component, 'index.entry.jsx').exist?
            Frails::Component::ReactComponentRenderer.new.render(context, options, &block)
          else
            options[:partial] = "#{component}/index"
            Frails::Component::ComponentRenderer.new(@lookup_context)
                                                .render(context, options, &block)
          end
        end
      end
    end
  end
end
