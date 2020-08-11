# frozen_string_literal: true

require 'test_helper'

class ManifestTest < Minitest::Test
  include SilenceLogger

  def test_lookup_exception!
    path = File.join(File.dirname(__FILE__), 'dummy/public/assets', 'manifest.json')
    manifest_path = File.expand_path(path.to_s)
    asset_file = 'calendar.js'

    error = assert_raises Frails::Manifest::MissingEntryError do
      Frails.manifest.lookup!(asset_file)
    end

    assert_match "Frails can't find #{asset_file} in #{manifest_path}", error.message
  end

  def test_lookup_success!
    assert_equal '/assets/bootstrap-300631c4f0e0f9c865bc.js',
                 Frails.manifest.lookup!('bootstrap.js')
  end

  def test_lookup_nil
    assert_nil Frails.manifest.lookup('foo.js')
  end

  def test_lookup_success
    assert_equal '/assets/bootstrap-300631c4f0e0f9c865bc.js', Frails.manifest.lookup('bootstrap.js')
  end

  def test_lookup_custom_manifest
    assert_equal '/assets/server/bootstrap-300631c4f0e0f9c865bc.js',
                 Frails.manifest['server.json'].lookup('bootstrap.js')
  end

  def test_unknown_manifest
    assert_raises Frails::Manifest::MissingManifestError do
      Frails.manifest['nuffin.json']
    end
  end
end
