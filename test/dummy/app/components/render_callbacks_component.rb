# frozen_string_literal: true

class RenderCallbacksComponent < Frails::Component::PlainComponent
  before_render :set_resource

  def locals
    {
      name: @resource[:name]
    }
  end

  private

    def set_resource
      @resource = { name: 'Joel Moss' }
    end
end
