# frozen_string_literal: true

class ErbComponent < Frails::Component::Base
  validates :content, presence: true

  def initialize(message:)
    @message = message
  end
end
