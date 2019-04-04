# frozen_string_literal: true

require 'test_helper'

class ManifestTest < Minitest::Test
  def test_lookup_exception!
    path = File.join(File.dirname(__FILE__), 'test_app/public/packs', 'manifest.json')
    manifest_path = File.expand_path(path.to_s)
    asset_file = 'calendar.js'

    error = assert_raises Frails::Manifest::MissingEntryError do
      Frails.manifest.lookup!(asset_file)
    end

    assert_match "Frails can't find #{asset_file} in #{manifest_path}", error.message
  end

  def test_lookup_success!
    assert_equal Frails.manifest.lookup!('bootstrap.js'), '/packs/bootstrap-300631c4f0e0f9c865bc.js'
  end

  def test_lookup_nil
    assert_nil Frails.manifest.lookup('foo.js')
  end

  def test_lookup_success
    assert_equal Frails.manifest.lookup('bootstrap.js'), '/packs/bootstrap-300631c4f0e0f9c865bc.js'
  end
end
