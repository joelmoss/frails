# frozen_string_literal: true

class Frails::Component::ComponentRenderer < ActionView::PartialRenderer
  include Frails::Component::RendererConcerns

  def render(context, options, &block)
    @view = context
    @component = options.delete(:component).to_s
    @presenter = presenter_class.new(@view, options)

    result = @presenter.run_callbacks :render do
      if @presenter.respond_to?(:render)
        @presenter.render(&block)
      else
        options[:locals] = @presenter.locals
        super context, options, block
      end
    end

    apply_styles((Rails::VERSION::MAJOR >= 6 ? result.body : result) || nil)
  end

  private

    def presenter_class
      super || Frails::Component::PlainComponent
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
        Rails.root.join('app', 'components', style_file).relative_path_from(Rails.root)
      end
    end
end
