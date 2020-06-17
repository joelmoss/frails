# frozen_string_literal: true

require 'test_helper'

class ManifestTest < Minitest::Test
  def test_lookup_entry_success!
    exp = { 'css' => ['/frails/assets/app.entry.css'], 'js' => ['/frails/assets/app.entry.js'] }
    assert_equal exp, Frails.manifest.lookup_entry!('assets/app')
  end

  def test_lookup_entry_exception!
    assert_raises Frails::Manifest::MissingEntryError do
      Frails.manifest.lookup_entry!('assets/blah')
    end
  end

  def test_lookup_entry_not_found
    assert_nil Frails.manifest.lookup_entry('assets/blah')
  end

  def test_lookup_entry_with_type
    assert_equal ['/frails/assets/app.entry.js'], Frails.manifest.lookup_entry('assets/app', :js)
  end

  def test_lookup_entry_with_type!
    assert_equal ['/frails/assets/app.entry.js'], Frails.manifest.lookup_entry!('assets/app', :js)
  end

  def test_lookup_exception!
    path = File.join(File.dirname(__FILE__), 'dummy/public/frails', 'manifest.json')
    manifest_path = File.expand_path(path.to_s)
    asset_file = 'calendar.js'

    error = assert_raises Frails::Manifest::MissingEntryError do
      Frails.manifest.lookup!(asset_file)
    end

    assert_match "Frails can't find #{asset_file} in #{manifest_path}", error.message
  end

  def test_lookup_success!
    assert_equal '/frails/bootstrap-300631c4f0e0f9c865bc.js',
                 Frails.manifest.lookup!('bootstrap.js')
  end

  def test_lookup_with_nested_path
    assert_equal ['/frails/assets/admin/index.entry.js'],
                 Frails.manifest.lookup!('assets/admin/index.entry', :js)
  end

  def test_lookup_nil
    assert_nil Frails.manifest.lookup('foo.js')
  end

  def test_lookup_success
    assert_equal '/frails/bootstrap-300631c4f0e0f9c865bc.js', Frails.manifest.lookup('bootstrap.js')
  end

  def test_lookup_custom_manifest
    assert_equal '/frails/server/bootstrap-300631c4f0e0f9c865bc.js',
                 Frails.manifest['server.json'].lookup('bootstrap.js')
  end

  def test_unknown_manifest
    assert_raises Frails::Manifest::MissingManifestError do
      Frails.manifest['nuffin.json']
    end
  end
end
