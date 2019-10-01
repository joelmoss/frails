# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module AbstractRenderer
        def side_load_assets(view, tpl)
          return unless view.controller._side_load_assets?

          path = tpl.short_identifier.delete_prefix('app/').delete_suffix('.html.erb')

          instrument :side_loaded_assets, identifier: tpl.identifier, asset_types: [] do |payload|
            side_load_javascript path, view, payload
            side_load_stylesheet path, view, payload
          end

          path
        end

        def side_load_javascript(path, view, payload)
          # Render the JS - if any.
          view.content_for :side_loaded_js do
            view.javascript_pack_tag(path, soft_lookup: true).tap do |tag|
              !tag.nil? && (payload[:asset_types] << :js)
            end
          end
        end

        def side_load_stylesheet(path, view, payload)
          loaded = side_loaded_stylesheets(view)

          # Don't inline the styles if already inlined.
          return if loaded.include?(path)

          # Render the CSS inline - if any.
          Frails.manifest.read(path, :stylesheet) do |href, src|
            view.content_for :side_loaded_css do
              view.content_tag :style, src, { data: { href: href } }, false
            end

            loaded << path
            payload[:asset_types] << :css
          end
        end

        def side_loaded_stylesheets(view)
          if view.instance_variable_defined?(:@side_loaded_stylesheets)
            view.instance_variable_get(:@side_loaded_stylesheets)
          else
            view.instance_variable_set :@side_loaded_stylesheets, []
          end
        end
      end
    end
  end
end
