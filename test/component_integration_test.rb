# frozen_string_literal: true

require 'test_helper'

class ComponentIntegrationTest < ActionDispatch::IntegrationTest
  test 'template only' do
    get '/nav'

    assert_response :success
    assert_select 'nav', 'My Navigation'
  end

  test 'with css' do
    get '/'

    assert_response :success
    assert_select 'footer', 1, 'My footer'
    assert_select "style[data-href='/assets/components/footer/index-26f6510bf15bc4da.css']",
                  count: 1,
                  text: "body {\n  color: aqua;\n}\n"
  end

  test 'multiple instances' do
    get '/angels'

    assert_response :success
    assert_select 'div', 2, text: 'My Angel'
    assert_select "style[data-href='/assets/components/angel/index-26f6510bf15bc4da.css']",
                  count: 1,
                  text: "body {\n  color: azure;\n}\n"
  end

  test 'content as block' do
    get '/child'

    assert_response :success
    assert_select 'nav', 'My Navigation<h1>A Title</h1>'
  end
end
