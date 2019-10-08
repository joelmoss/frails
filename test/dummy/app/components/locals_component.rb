# frozen_string_literal: true

class LocalsComponent < Frails::Component::PlainComponent
  def locals
    { first_name: 'Joel' }.deep_merge(super)
  end

  def middle_initial
    'K'
  end
end
