# frozen_string_literal: true

class WithoutTemplateComponent < Frails::Component::Base
  def render
    tag.div 'without_template'
  end
end
