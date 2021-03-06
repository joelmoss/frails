# frozen_string_literal: true

require 'test_helper'

class ComponentIntegrationTest < ActionDispatch::IntegrationTest
  test 'with css' do
    get '/components/template_with_css'

    assert_select 'div', count: 2, text: 'template_with_css'
    assert_select 'span.description-53e9bf', count: 2, text: 'description'
    assert_select "style[data-href='/assets/components/template_with_css/index.css']",
                  count: 1, text: "div {\n  color: red;\n}\n"
  end

  test 'content as block' do
    get '/components/with_children'

    assert_select 'span' do
      assert_select 'h1', 'template_with_css'
      assert_select 'h2', 'Hello children'
    end
  end

  test 'component templates restricted to app/components' do
    get '/components/restricted_templates'

    assert_select 'div', 'restricted_templates'
    assert_select 'p', 'test partial'
  end

  test 'access to view instance vars' do
    get '/components/view_instance_vars'

    assert_select 'div', 'view_instance_vars - 42'
  end
end
