# frozen_string_literal: true

module Frails::Component::RendererConcerns
  extend ActiveSupport::Concern

  private

    def presenter_class
      klass_file = Rails.root.join('app', 'components', "#{@component}_component.rb")
      klass_file.exist? && "#{@component.to_s.camelcase}Component".constantize
    end

    def render_inline_styles
      # TODO: We don't yet have support for compiling Webpack for tests.
      return if Rails.env.test?

      # Don't inline the styles if already inlined.
      return if inlined_stylesheets.include?(@component)

      Frails.manifest.read(stylesheet_entry_file, :stylesheet) do |path, src|
        @view.content_for :component_styles do
          @view.content_tag(:style, src, { data: { href: path } }, false)
        end

        inlined_stylesheets << @component
      end
    end

    def inlined_stylesheets
      if @view.instance_variable_defined?(:@inlined_stylesheets)
        @view.instance_variable_get :@inlined_stylesheets
      else
        @view.instance_variable_set :@inlined_stylesheets, []
      end
    end
end
