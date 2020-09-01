# frozen_string_literal: true

class Frails::Component::Abstract
  include ActiveSupport::Callbacks

  define_callbacks :render
  attr_reader :path

  def initialize(view, path, options)
    @view = view
    @path = path
    @options = options

    expand_instance_vars
  end

  class << self
    def before_render(*methods, &block)
      set_callback :render, :before, *methods, &block
    end

    def after_render(*methods, &block)
      set_callback :render, :after, *methods, &block
    end
  end

  # rubocop:disable Lint/ShadowedException, Style/MissingRespondToMissing
  def method_missing(method, *args, &block)
    super
  rescue NoMethodError, NameError => e
    # the error is not mine, so just releases it as is.
    raise e if e.name != method

    begin
      @view.send method, *args, &block
    rescue NoMethodError => e
      raise e if e.name != method

      raise NoMethodError.new("undefined method `#{method}' for either #{self} or #{@view}",
                              method)
    rescue NameError => e
      raise e if e.name != method

      raise NameError.new("undefined local variable `#{method}' for either #{self} or #{@view}",
                          method)
    end
  end
  # rubocop:enable Style/MissingRespondToMissing, Lint/ShadowedException

  private

    # Define instance variables for those that are already defined in the @view_context. Excludes
    # variables starting with an underscore.
    def expand_instance_vars
      @view.instance_variables.each do |var|
        next if var.to_s.start_with?('@_')

        instance_variable_set var, @view.instance_variable_get(var)
      end
    end
end
