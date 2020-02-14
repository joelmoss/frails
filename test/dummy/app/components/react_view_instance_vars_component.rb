# frozen_string_literal: true

class ReactViewInstanceVarsComponent < Frails::Component::React
  def props
    { age: @age }
  end
end
