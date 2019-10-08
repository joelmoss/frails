# frozen_string_literal: true

class WithoutTemplateComponent < Frails::Component::PlainComponent
  def render
    tag.div 'without_template'
  end
end
