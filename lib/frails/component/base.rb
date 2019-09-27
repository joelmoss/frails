# frozen_string_literal: true

class Frails::Component::Base < ActionView::Base
  include ActiveModel::Validations

  # Entrypoint for rendering components. Called by ActionView::Base#render.
  #
  # view_context: ActionView context from calling view
  # args(hash): params to be passed to component being rendered
  # block: optional block to be captured within the view context
  #
  # returns HTML that has been escaped by the respective template handler
  #
  # Example subclass:
  #
  # app/components/my_component.rb:
  # class MyComponent < Frails::Component::Base
  #   def initialize(title:)
  #     @title = title
  #   end
  # end
  #
  # app/components/my_component/index.html.erb
  # <span title="<%= @title %>">Hello, <%= content %>!</span>
  #
  # In use:
  # <%= render MyComponent, title: "greeting" do %>world<% end %>
  # or
  # <%= render component: :my, locals: { title: "greeting" } do %>world<% end %>
  # returns:
  # <span title="greeting">Hello, world!</span>
  #
  def render_in(view_context, *_args, &block)
    self.class.compile
    @content = view_context.capture(&block) if block_given?
    validate!
    call
  end

  def initialize(*); end

  class << self
    def inherited(child)
      unless child < Rails.application.routes.url_helpers
        child.include Rails.application.routes.url_helpers
      end

      super
    end

    # Compile template to #call instance method, assuming it hasn't been compiled already.
    # We could in theory do this on app boot, at least in production environments.
    # Right now this just compiles the template the first time the component is rendered.
    def compile
      return if @compiled && ActionView::Base.cache_template_loading

      tpl = "def call; @output_buffer = ActionView::OutputBuffer.new; #{compiled_template}; end"
      class_eval tpl, __FILE__, __LINE__

      @compiled = true
    end

    private

      def compiled_template
        handler = ActionView::Template.handler_for_extension(File.extname(template_file_path).gsub('.', ''))
        template = File.read(template_file_path)

        if handler.method(:call).parameters.length > 1
          handler.call(DummyTemplate.new, template)
        else
          handler.call(DummyTemplate.new(template))
        end
      end

      def template_file_path
        name = to_s.delete_suffix('Component').underscore
        dir = Rails.root.join('app', 'components', name)

        if (template = dir.join('_index.html.erb')).exist?
          ActiveSupport::Deprecation.warn 'Underscored prefix (_index.html.erb) of template ' \
                                          'names are deprecated. Please get rid of the prefixed ' \
                                          'underscore.'

          return template
        end

        return template if (template = dir.join('index.html.erb')).exist?

        raise NotImplementedError, "Could not find a template file for #{self}."
      end
  end

  class DummyTemplate
    attr_reader :source

    def initialize(source = nil)
      @source = source
    end

    def identifier
      ''
    end

    # we'll eventually want to update this to support other types
    def type
      'text/html'
    end
  end

  private

    attr_reader :content
end
