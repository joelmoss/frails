# frozen_string_literal: true

class Frails::Component::Renderer < ActionView::PartialRenderer
  include Frails::Component::RendererConcerns

  # Overwritten to make sure we don't lookup partials. Even though this inherits from the
  # PartialRenderer, component templates do not have the underscore prefix that partials have.
  #
  # Additionally, this will ensure that ONLY the app/components directory is used as the only view
  # path to search within when looking up the component template.
  def find_template(path, locals)
    path_count = @lookup_context.view_paths.size
    @lookup_context.view_paths.unshift Frails.components_path
    old_paths = @lookup_context.view_paths.pop(path_count)

    prefixes = path.include?('/') ? [] : @lookup_context.prefixes
    result = @lookup_context.find_template(path, prefixes, false, locals, @details)

    @lookup_context.view_paths.unshift(*old_paths)
    @lookup_context.view_paths.pop

    result
  end

  def render(context, options, &block)
    @view = context
    @component = options.delete(:component)

    klass = presenter_class
    @presenter = klass.new(@view, @component, options)

    @children = block_given? ? @view.capture(&block) : nil
    options[:partial] = @presenter

    result = @presenter.run_callbacks :render do
      if @presenter.respond_to?(:render)
        @presenter.render(&block)
      else
        options[:locals] = @presenter.locals
        options[:locals][:children] = @children
        super context, options, block
      end
    end

    apply_styles((result.respond_to?(:body) ? result.body : result) || nil)
  end

  private

    def presenter_class
      super || Frails::Component::Base
    end

    def apply_styles(content)
      return nil if content.nil?

      render_inline_styles
      replace_css_module_attribute(content).html_safe
    end

    def stylesheet_entry_file
      "components/#{@component}/index"
    end

    def replace_css_module_attribute(content)
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
      hash_digest = Digest::MD5.hexdigest("#{stylesheet_path}+#{local_name}")[0, 6]

      return "#{local_name}-#{hash_digest}" unless Frails.dev_server.running?

      name = stylesheet_path.basename.sub(stylesheet_path.extname, '').sub('.', '-')
      ident = +"#{name}__#{local_name}___#{hash_digest}"
      ident.prepend("#{stylesheet_path.dirname.to_s.tr('/', '-')}-")
      ident
    end

    def stylesheet_path
      @stylesheet_path ||= begin
        style_file = "#{@component}/index.css"
        Frails.components_path.join(style_file).relative_path_from(Rails.root)
      end
    end
end
