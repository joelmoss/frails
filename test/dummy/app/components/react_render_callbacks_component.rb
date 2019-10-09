# frozen_string_literal: true

class ReactRenderCallbacksComponent < Frails::Component::React
  before_render :set_location

  def props
    { location: @location }
  end

  private

    def set_location
      @location = 'Chorley'
    end
end
