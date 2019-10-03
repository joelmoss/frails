# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module TemplateRenderer
        def render(context, options)
          # See Frails::SideLoadAssets
          @side_load_assets = options.key?(:side_load_assets) ? options[:side_load_assets] : false

          super
        end

        def render_template(view, template, layout_name, locals)
          return super if !@side_load_assets || template.type != :html

          # Side load layout assets - if any.
          if layout_name
            layout = find_layout(layout_name, locals.keys, [formats.first])
            layout && side_load_assets(view, layout)
          end

          # Side load view assets - if any.
          side_load_assets view, template

          super
        end
      end
    end
  end
end
