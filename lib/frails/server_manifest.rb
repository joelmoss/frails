# frozen_string_literal: true

class Frails::ServerManifest < Frails::Manifest
  def manifest_path
    @manifest_path ||= Rails.root.join('public', 'packs', 'server-manifest.json')
  end
end
