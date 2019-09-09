# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module RenderingHelper
        def render(options = {}, locals = {}, &block)
          case options
          when Hash
            if Rails::VERSION::MAJOR >= 6
              in_rendering_context(options) do |renderer|
                if block_given?
                  # MONKEY PATCH! simply renders the component with the given block.
                  if options.key?(:component)
                    return view_renderer.render_component(self, options, &block)
                  end

                  view_renderer.render_partial(self, options.merge(partial: options[:layout]), &block)
                else
                  view_renderer.render(self, options)
                end
              end
            else
              if block_given?
                # MONKEY PATCH! simply renders the component with the given block.
                if options.key?(:component)
                  return view_renderer.render_component(self, options, &block)
                end

                view_renderer.render_partial(self, options.merge(partial: options[:layout]), &block)
              else
                view_renderer.render(self, options)
              end
            end
          else
            view_renderer.render_partial(self, partial: options, locals: locals, &block)
          end
        end
      end
    end
  end
end