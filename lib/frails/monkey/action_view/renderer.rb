# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module Renderer
        def render_to_object(context, options) # :nodoc:
          if options.key?(:partial)
            render_partial_to_object(context, options)
          elsif options.key?(:component)
            render_component_to_object(context, options)
          else
            render_template_to_object(context, options)
          end
        end

        def render_component_to_object(context, options, &block)
          component = options[:component].to_s

          result = if Rails.root.join('app', 'components', component, 'index.entry.jsx').exist?
                     Frails::Component::ReactComponentRenderer.new.render(context, options, &block)
                   else
                     options[:partial] = "#{component}/index"
                     Frails::Component::ComponentRenderer.new(@lookup_context)
                                                         .render(context, options, &block)
                   end

          ::ActionView::AbstractRenderer::RenderedTemplate.new result, nil, nil
        end
      end
    end
  end
end