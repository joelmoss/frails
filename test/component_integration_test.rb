# frozen_string_literal: true

require 'test_helper'

class ComponentIntegrationTest < ActionDispatch::IntegrationTest
  test 'template only' do
    get '/components/template_only'

    assert_response :success
    assert_select 'div', 'template_only'
  end

  test 'with css' do
    get '/components/template_with_css'

    assert_response :success
    assert_select 'div', count: 2, text: 'template_with_css'
    assert_select "style[data-href='/assets/components/template_with_css/index.css']",
                  count: 1, text: "div {\n  color: red;\n}\n"
  end

  test 'content as block' do
    get '/components/with_children'

    assert_response :success
    assert_select 'h1', 'template_with_css'
    assert_select 'h2', 'Hello children'
  end
end
