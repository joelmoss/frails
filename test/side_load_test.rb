# frozen_string_literal: true

require 'test_helper'

class SideLoadTest < ActionDispatch::IntegrationTest
  test 'styles' do
    get '/'

    assert_select 'head' do
      # Order matters here, so layout, then view, then partials.
      assert_select 'style:nth(1)', text: 'body{font-size:16px;color:red}'
      assert_select 'style:nth(2)', text: 'body{color:#000}'
      assert_select 'style:nth(3)', text: '.app-views-pages-_header__title___7e96e3{color:#00f}'
    end
  end

  test 'no side load' do
    get '/no_side_load'

    assert_select 'style', false
  end

  test 'javascripts' do
    get '/'

    assert_select 'body' do
      # Order matters here, so layout, then view, then partials.
      assert_select 'script:nth(1)[src=?]', '/assets/views/layouts/application.js'
      # assert_select 'script:nth(2)[src=?]', '/assets/views/pages/home-26f6510bf15bc4da.js'
      # assert_select 'script:nth(3)[src=?]', '/assets/views/pages/_header-26f6510bf15bc4da.js'
    end
  end

  test 'only html templates' do
    get '/about.json'

    assert_response :success
  end

  test 'multiple of the same partial' do
    get '/about'

    assert_select 'head' do
      assert_select 'style:nth(1)', text: 'body{font-size:16px;color:red}' # layout
      assert_select 'style:nth(2)', text: '.app-views-pages-_header__title___7e96e3{color:#00f}'
    end

    assert_select 'body' do
      # Order matters here, so layout, then view, then partials.
      assert_select 'script:nth(1)[src=?]', '/assets/views/layouts/application.js'
      assert_select 'script:nth(2)[src=?]', '/assets/views/pages/_header.js'
    end
  end

  test 'partial using css_module, but has no css asset' do
    get '/partial_no_css'

    assert_select 'head' do
      assert_select 'style', count: 1, text: 'body{font-size:16px;color:red}'
    end
    assert_select 'h1', 'title'
    assert_select 'h2', 'subtitle'
  end

  test 'partial with collection' do
    get '/partial_collection'

    assert_select 'head' do
      assert_select 'style:nth(1)', text: 'body{font-size:16px;color:red}'
      assert_select 'style:nth(2)', text: '.app-views-pages-_post__title___afcba4{font-size:20px}'
    end
    assert_select 'h1.app-views-pages-_post__title___afcba4:nth(1)', 'title1'
    assert_select 'h1.app-views-pages-_post__title___afcba4:nth(2)', 'title2'
  end
end
