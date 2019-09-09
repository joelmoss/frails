# frozen_string_literal: true

class Frails::Component::ReactComponentRenderer
  include Frails::Component::RendererConcerns

  def render(context, options, &block)
    @view = context
    @component = options.delete(:component).to_s
    @presenter = presenter_class.new(@view, options)

    @children = @view.capture(&block) if block_given?

    render_with_callbacks || nil
  end

  private

    # rubocop:disable Rails/OutputSafety
    def render_with_callbacks
      @presenter.run_callbacks :render do
        @prerender = @presenter.prerender
        @content_loader = @presenter.content_loader
        @props = camelize_keys(@presenter.props)
        @props[:children] = @children if @children

        @prerender && render_inline_styles

        rendered_tag = content_tag do
          @prerender ? React::Renderer.new.render(@component, @props).html_safe : loader
        end

        @prerender ? move_console_replay_script(rendered_tag) : rendered_tag
      end
    end
    # rubocop:enable Rails/OutputSafety

    def presenter_class
      super || Frails::Component::ReactComponent
    end

    def data_for_content_tag
      {
        componentPath: @component,
        componentName: @component.to_s.tr('/', '_').camelize,
        props: @props,
        contentLoader: @content_loader,
        renderMethod: @prerender ? 'hydrate' : 'render'
      }.to_json
    end

    def content_tag(&block)
      classes = "js__reactComponent #{@presenter.class_name}"
      @view.content_tag @presenter.tag, class: classes, data: data_for_content_tag, &block
    end

    def camelize_keys(data)
      data.deep_transform_keys { |key| key.to_s.camelize :lower }
    end

    def loader
      return unless @content_loader

      @view.render "shared/content_loaders/#{@content_loader == true ? 'code' : @content_loader}"
    end

    # Grab the server-rendered console replay script and move it outside the container div.
    #
    # rubocop:disable Rails/OutputSafety, Style/RegexpLiteral
    def move_console_replay_script(rendered_tag)
      regex = /\n(<script class="js__reactServerConsoleReplay">.*<\/script>)<\/(\w+)>$/m
      rendered_tag.sub(regex, '</\2>\1').html_safe
    end
    # rubocop:enable Rails/OutputSafety, Style/RegexpLiteral

    def stylesheet_entry_file
      "#{@component.tr('/', '-')}-index-entry-jsx"
    end
end