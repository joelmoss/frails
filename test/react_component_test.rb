# frozen_string_literal: true

require 'test_helper'

class ReactComponentTest < ActionDispatch::IntegrationTest
  include SilenceLogger

  test 'react' do
    get '/react'

    assert_select 'section', count: 1 do |_html|
      assert_select 'div.js__reactComponent', count: 1 do |html|
        data = JSON.parse(html.first.attribute('data').value)

        assert_equal 'react', data['componentPath']
        assert_equal 'React', data['componentName']
        assert_equal({}, data['props'])
        assert_equal false, data['contentLoader']
        assert_equal 'render', data['renderMethod']
      end
    end
  end

  # test 'pre-rendered' do
  #   get '/react'

  #   pp response.body

  #   assert_select "style[data-href='/assets/components/react/index.css']",
  #                 count: 1, text: "div {\n  color: red;\n}\n"
  # end

  test 'access to view instance vars' do
    get '/react/view_instance_vars'

    assert_select 'div.js__reactComponent', count: 1 do |html|
      data = JSON.parse(html.first.attribute('data').value)

      assert_equal({ 'age' => 42 }, data['props'])
    end
  end
end
