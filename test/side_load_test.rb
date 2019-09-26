# frozen_string_literal: true

require 'test_helper'

class SideLoadTest < ActionDispatch::IntegrationTest
  test 'styles' do
    get '/'

    assert_response :success

    assert_select 'head' do
      assert_select 'style', 3

      # Order matters here, so layout, then view, then partials.
      assert_select 'style:nth(1)', text: "body {\n  color: red;\n}\n"
      assert_select 'style:nth(2)', text: "body {\n  color: black;\n}\n"
      assert_select 'style:nth(3)', text: ".app-views-pages-_header__title___abc123 {\n  color: blue;\n}\n"
    end
  end

  test 'javascripts' do
    get '/'

    assert_response :success

    assert_select 'body' do
      assert_select 'script', 3

      # Order matters here, so layout, then view, then partials.
      assert_select 'script:nth(1)[src=?]', '/assets/views/layouts/application-26f6510bf15bc4da.js'
      assert_select 'script:nth(2)[src=?]', '/assets/views/pages/home-26f6510bf15bc4da.js'
      assert_select 'script:nth(3)[src=?]', '/assets/views/pages/_header-26f6510bf15bc4da.js'
    end
  end

  test 'multiple of the same partial' do
    get '/about'

    assert_response :success

    assert_select 'head' do
      assert_select 'style', 2
      assert_select 'style:nth(1)', text: "body {\n  color: red;\n}\n" # layout
      assert_select 'style:nth(2)', text: ".app-views-pages-_header__title___abc123 {\n  color: blue;\n}\n"
    end

    assert_select 'body' do
      assert_select 'script', 2

      # Order matters here, so layout, then view, then partials.
      assert_select 'script:nth(1)[src=?]', '/assets/views/layouts/application-26f6510bf15bc4da.js'
      assert_select 'script:nth(2)[src=?]', '/assets/views/pages/_header-26f6510bf15bc4da.js'
    end
  end
end
