# frozen_string_literal: true

require 'test_helper'

class Frails::ComponentTest < Minitest::Test
  include SilenceLogger
  include Frails::Component::TestHelpers

  def test_with_template
    result = controller.view_context.render(component: :template_only)

    assert_equal result, '<div>template_only</div>'
  end

  def test_without_template
    result = controller.view_context.render(component: :without_template)

    assert_equal result, '<div>without_template</div>'
  end

  def test_locals
    result = controller.view_context.render(component: :locals, last_name: 'Moss')

    assert_equal result, '<div>locals - Joel K Moss</div>'
  end

  def test_render_callbacks
    result = controller.view_context.render(component: :render_callbacks)

    assert_equal result, '<div>render_callbacks - Joel Moss</div>'
  end

  def test_call_render
    result = controller.view_context.render(MyComponent, 'joel', 'moss', age: 42)

    assert_equal result, '<div>my_component joel moss 42</div>'
  end
end
