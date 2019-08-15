# frozen_string_literal: true

class Frails::Component::ReactComponent < Frails::Component::AbstractComponent
  attr_accessor :class_name, :props, :tag, :prerender, :content_loader

  def initialize(view, options)
    @view, @options = view, options

    @class_name = @options.fetch(:class, nil)
    @props = @options.fetch(:props, {})
    @tag = @options.fetch(:tag, :div)
    @prerender = @options.fetch(:prerender, false)
    @content_loader = @options.fetch(:content_loader, false)

    expand_instance_vars
  end
end
