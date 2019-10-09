# frozen_string_literal: true

class Frails::Component::Base < Frails::Component::Abstract
  PRIVATE_METHODS = %i[render method_missing locals].freeze

  def initialize(view, options)
    super

    @locals = @options.fetch(:locals, @options)
  end

  def locals
    hash = {}
    public_methods(false).each do |method|
      hash[method] = send(method) unless PRIVATE_METHODS.include?(method)
    end
    hash.merge @locals
  end
end
