# frozen_string_literal: true

module Frails
  module Monkey
    module ActionView
      module PartialRenderer
        def render_partial(view, template)
          # Side load partial assets - if any.
          @asset_path = @side_load_assets && side_load_assets(view, template)

          super
        end

        def setup(context, options, as, block)
          @side_load_assets = options.key?(:side_load_assets) ? options[:side_load_assets] : false

          super
        end

        def build_rendered_template(content, template, layout = nil)
          content = transform_css_modules(content).html_safe if @asset_path
          super
        end

        def transform_css_modules(content)
          doc = Nokogiri::HTML::DocumentFragment.parse(content)

          return content if (modules = doc.css('[css_module]')).empty?

          modules.each do |ele|
            classes = class_name_for_style(ele.delete('css_module'))
            ele['class'] = (ele['class'].nil? ? classes : classes << ele['class']).join(' ')
          end

          doc.to_html
        end

        def class_name_for_style(class_names)
          class_names.to_s.split.map { |class_name| build_ident class_name }
        end

        def build_ident(local_name)
          path = Rails.root.join('app', "#{@asset_path}.css").relative_path_from(Rails.root)
          hash_digest = Digest::MD5.hexdigest("#{path}+#{local_name}")[0, 6]

          return "#{local_name}-#{hash_digest}" unless Frails.dev_server.running?

          name = path.basename.sub(path.extname, '').sub('.', '-')
          ident = +"#{name}__#{local_name}___#{hash_digest}"
          ident.prepend("#{path.dirname.to_s.tr('/', '-')}-")
          ident
        end
      end
    end
  end
end
