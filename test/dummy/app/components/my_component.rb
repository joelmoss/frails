# frozen_string_literal: true

class MyComponent < Frails::Component::Base
  def render
    opts = @locals.extract_options!
    first_name, last_name = @locals

    tag.div "my_component #{first_name} #{last_name} #{opts[:age]}"
  end
end
