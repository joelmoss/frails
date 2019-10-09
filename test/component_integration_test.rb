# frozen_string_literal: true

require 'test_helper'

class ComponentIntegrationTest < ActionDispatch::IntegrationTest
  test 'template only' do
    get '/components/template_only'

    assert_response :success
    assert_select 'div', 'template_only'
  end

  test 'locals' do
    get '/components/locals'

    assert_response :success
    assert_select 'div', 'locals - Joel K Moss'
  end

  test 'without template' do
    get '/components/without_template'

    assert_response :success
    assert_select 'div', 'without_template'
  end

  test 'render callbacks' do
    get '/components/render_callbacks'

    assert_response :success
    assert_select 'div', 'render_callbacks - Joel Moss'
  end

  test 'with css' do
    get '/components/template_with_css'

    assert_response :success
    assert_select 'div', count: 2, text: 'template_with_css'
    assert_select 'span' do
      assert_select '[class="description-3c07c9"]'
    end
    assert_select "style[data-href='/assets/components/template_with_css/index.css']",
                  count: 1, text: "div {\n  color: red;\n}\n"
  end

  test 'content as block' do
    get '/components/with_children'

    assert_response :success
    assert_select 'h1', 'template_with_css'
    assert_select 'h2', 'Hello children'
  end

  test 'component templates restricted to app/components' do
    get '/components/restricted_templates'

    assert_response :success
    assert_select 'div', 'restricted_templates'
    assert_select 'p', 'test partial'
  end

  test 'access to view instance vars' do
    get '/components/view_instance_vars'

    assert_response :success
    assert_select 'div', 'view_instance_vars - 42'
  end
end
