# frozen_string_literal: true

require 'frails/manifest'

class Frails::ManifestManager
  delegate :lookup, :lookup!, :read, :read!, to: :default_instance

  def initialize
    @instances = {}
  end

  def [](path = nil)
    path ||= Frails.manifest_path
    @instances[path] ||= Frails::Manifest.new(path)
  end

  private

    def default_instance
      @instances[Frails.manifest_path] ||= Frails::Manifest.new(Frails.manifest_path)
    end
end
