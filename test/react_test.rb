# frozen_string_literal: true

require 'test_helper'

class Frails::ReactTest < Minitest::Test
  include Frails::Component::TestHelpers

  def test_with_template
    result = render_inline(component: :react)
    data = JSON.parse(result.css('div.js__reactComponent').first.attribute('data').value)

    assert_equal 'react', data['componentPath']
    assert_equal 'React', data['componentName']
    assert_equal false, data['contentLoader']
    assert_equal 'render', data['renderMethod']
  end

  def test_props
    result = render_inline(component: :react, props: { first_name: 'Joel' })
    data = JSON.parse(result.css('div.js__reactComponent').first.attribute('data').value)

    assert_equal({ 'firstName' => 'Joel' }, data['props'])
  end

  def test_children
    result = render_inline(component: :react) { '<span>children</span>' }
    data = JSON.parse(result.css('div.js__reactComponent').first.attribute('data').value)

    assert_equal '&lt;span&gt;children&lt;/span&gt;', data['props']['children']
  end

  def test_class_name
    result = render_inline(component: :react, class: 'my_class')

    refute_empty result.css('div.js__reactComponent.my_class')
  end

  def test_tag_name
    result = render_inline(component: :react, tag: 'span')

    refute_empty result.css('span.js__reactComponent')
  end

  def test_render_callbacks
    result = render_inline(component: :react_render_callbacks)
    data = JSON.parse(result.css('div.js__reactComponent').first.attribute('data').value)

    assert_equal({ 'location' => 'Chorley' }, data['props'])
  end
end
