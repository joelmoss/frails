# frozen_string_literal: true

class WrapperComponent < Frails::Component::Base
  validates :content, presence: true
end
