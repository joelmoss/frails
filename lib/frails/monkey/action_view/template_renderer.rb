# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module TemplateRenderer
        def render_template(view, template, layout_name, locals)
          # Side load layout assets - if any.
          if layout_name
            layout = find_layout(layout_name, locals.keys, [formats.first])
            side_load_assets view, layout
          end

          # Side load view assets - if any.
          side_load_assets view, template

          super
        end
      end
    end
  end
end
