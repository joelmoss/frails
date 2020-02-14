# frozen_string_literal: true

class Frails::Component::React < Frails::Component::Abstract
  attr_accessor :class_name, :props, :tag, :prerender, :content_loader

  def initialize(view, path, options)
    super

    @class_name = @options.fetch(:class, nil)
    @props = @options.fetch(:props, {})
    @tag = @options.fetch(:tag, :div)
    @prerender = @options.fetch(:prerender, false)
    @content_loader = @options.fetch(:content_loader, false)
  end
end
