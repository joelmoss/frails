# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module Renderer
        def render_to_object(context, options)
          if options.key?(:partial)
            render_partial_to_object(context, options)
          elsif options.key?(:component)
            render_component_to_object(context, options)
          else
            render_template_to_object(context, options)
          end
        end

        # Direct access to partial rendering.
        def render_component(context, options, &block)
          render_component_to_object(context, options, &block).body
        end

        def render_component_to_object(context, options, &block)
          component = options[:component].to_s

          result = if Frails.components_path.join(component, 'index.entry.jsx').exist?
                     Frails::Component::ReactRenderer.new(context, options).render(&block)
                   else
                     Frails::Component::Renderer.new(@lookup_context)
                                                .render(context, options, &block)
                   end

          ::ActionView::AbstractRenderer::RenderedTemplate.new result, nil, nil
        end
      end
    end
  end
end
