# frozen_string_literal: true

require 'test_helper'

class HelperTest < ActionView::TestCase
  tests Frails::Helper

  def setup
    @request = Class.new do
      def send_early_hints(links) end

      def base_url
        'https://example.com'
      end
    end.new
  end

  def test_image_tag
    assert_equal '<img src="/assets/images/background.png" />', image_tag('background.png')
  end

  def test_include_entry_pack
    include_entry_pack 'blocks/assets'

    assert_equal '<script src="/assets/assets/blocks/assets/index.entry.js"></script>', content_for(:js)
    assert_equal '<link rel="stylesheet" media="screen" href="/assets/assets/blocks/assets/index.entry.css" />',
                 content_for(:css)
  end

  def test_entry_pack_tags
    expected = ['<link rel="stylesheet" media="screen" href="/assets/assets/blocks/assets/index.entry.css" />',
                '<script src="/assets/assets/blocks/assets/index.entry.js"></script>']
    assert_equal expected, entry_pack_tags('blocks/assets')
  end

  def test_javascript_entry_pack_tag
    assert_equal '<script src="/assets/assets/blocks/assets/index.entry.js"></script>',
                 javascript_entry_pack_tag('blocks/assets')
  end

  def test_stylesheet_entry_pack_tag
    assert_equal '<link rel="stylesheet" media="screen" href="/assets/assets/blocks/assets/index.entry.css" />',
                 stylesheet_entry_pack_tag('blocks/assets')
  end

  def test_pack_path
    assert_equal '/frails/bootstrap-300631c4f0e0f9c865bc.js', pack_path('bootstrap.js')
    assert_equal '/frails/bootstrap-c38deda30895059837cf.css', pack_path('bootstrap.css')
  end

  test 'asset_entry_path without type or extension' do
    assert_raises(ArgumentError) { asset_entry_path('application') }
  end

  test 'asset_entry_path with type' do
    assert_equal '/frails/assets/application.entry.js', asset_entry_path('application', type: :js)
  end

  def test_asset_entry_path
    assert_equal '/frails/bootstrap-c38deda30895059837cf.css', asset_entry_path('application.js')
  end

  def test_pack_path_with_custom_manifest
    assert_equal '/frails/server/bootstrap-300631c4f0e0f9c865bc.js',
                 pack_path('bootstrap.js', manifest: 'server.json')
  end

  def test_pack_path_with_custom_manifest_from_env
    orig = Frails.manifest_path

    Frails.manifest_path = 'server.json'
    assert_equal '/frails/server/bootstrap-300631c4f0e0f9c865bc.js', pack_path('bootstrap.js')

    Frails.manifest_path = orig
  end

  def test_image_pack_tag
    assert_equal '<img src="/frails/images/logo-k344a6d59eef8632c9d1.png" />',
                 image_pack_tag('logo.png')
  end

  def test_image_pack_tag_with_custom_manifest
    assert_equal '<img src="/frails/server/images/logo-k344a6d59eef8632c9d1.png" />',
                 image_pack_tag('logo.png', manifest: 'server.json')
  end

  def test_stylesheet_pack_tag
    exp = '<link rel="stylesheet" media="screen" ' \
          'href="/frails/bootstrap-c38deda30895059837cf.css" />'
    assert_equal exp, stylesheet_pack_tag('bootstrap.css')
    assert_equal exp, stylesheet_pack_tag('bootstrap')
  end

  def test_stylesheet_pack_tag_with_manifest
    assert_equal '<link rel="stylesheet" media="screen" ' \
                 'href="/frails/server/bootstrap-c38deda30895059837cf.css" />',
                 stylesheet_pack_tag('bootstrap', manifest: 'server.json')
  end

  def test_stylesheet_pack_tag_soft_lookup
    assert_raises Frails::Manifest::MissingEntryError do
      stylesheet_pack_tag('nuffin.css')
    end
    assert_raises Frails::Manifest::MissingEntryError do
      stylesheet_pack_tag('nuffin.css', soft_lookup: false)
    end
    assert_nothing_raised do
      stylesheet_pack_tag('nuffin.css', soft_lookup: true)
    end
  end

  def test_javascript_pack_tag
    exp = '<script src="/frails/bootstrap-300631c4f0e0f9c865bc.js"></script>'
    assert_equal exp, javascript_pack_tag('bootstrap.js')
    assert_nil javascript_pack_tag('bootstrap')
  end

  def test_javascript_pack_tag_soft_lookup
    assert_raises Frails::Manifest::MissingEntryError do
      javascript_pack_tag('nuffin.js')
    end
    assert_raises Frails::Manifest::MissingEntryError do
      javascript_pack_tag('nuffin.js', soft_lookup: false)
    end
    assert_nothing_raised do
      javascript_pack_tag('nuffin.js', soft_lookup: true)
    end
  end

  def test_javascript_pack_tag_with_manifest
    exp = '<script src="/frails/server/bootstrap-300631c4f0e0f9c865bc.js"></script>'
    assert_equal exp, javascript_pack_tag('bootstrap.js', manifest: 'server.json')
  end
end
