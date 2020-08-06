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

  def test_pack_path
    assert_equal '/assets/bootstrap-300631c4f0e0f9c865bc.js', pack_path('bootstrap.js')
    assert_equal '/assets/bootstrap-c38deda30895059837cf.css', pack_path('bootstrap.css')
  end

  def test_pack_path_with_custom_manifest
    assert_equal '/assets/server/bootstrap-300631c4f0e0f9c865bc.js',
                 pack_path('bootstrap.js', manifest: 'server.json')
  end

  def test_pack_path_with_custom_manifest_from_env
    orig = Frails.manifest_path

    Frails.manifest_path = 'server.json'
    assert_equal '/assets/server/bootstrap-300631c4f0e0f9c865bc.js',
                 pack_path('bootstrap.js')

    Frails.manifest_path = orig
  end

  def test_image_pack_tag
    assert_equal '<img src="/assets/images/logo-k344a6d59eef8632c9d1.png" />',
                 image_pack_tag('logo.png')
  end

  def test_image_pack_tag_with_custom_manifest
    assert_equal '<img src="/assets/server/images/logo-k344a6d59eef8632c9d1.png" />',
                 image_pack_tag('logo.png', manifest: 'server.json')
  end

  def test_stylesheet_pack_tag
    exp = '<link rel="stylesheet" media="screen" ' \
          'href="/assets/bootstrap-c38deda30895059837cf.css" />'
    assert_equal exp, stylesheet_pack_tag('bootstrap.css')
    assert_equal exp, stylesheet_pack_tag('bootstrap')
  end

  def test_stylesheet_pack_tag_with_manifest
    assert_equal '<link rel="stylesheet" media="screen" ' \
                 'href="/assets/server/bootstrap-c38deda30895059837cf.css" />',
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
    exp = '<script src="/assets/bootstrap-300631c4f0e0f9c865bc.js"></script>'
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
    exp = '<script src="/assets/server/bootstrap-300631c4f0e0f9c865bc.js"></script>'
    assert_equal exp, javascript_pack_tag('bootstrap.js', manifest: 'server.json')
  end
end
