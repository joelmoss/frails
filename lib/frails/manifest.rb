# frozen_string_literal: true

require 'open-uri'

class Frails::Manifest
  class MissingManifestError < StandardError; end
  class MissingEntryError < StandardError; end

  attr_reader :manifest_path

  def initialize(path)
    @manifest_path = Rails.public_path.join(Frails.public_output_path, path)

    return if @manifest_path.exist?

    raise Frails::Manifest::MissingManifestError, "Cannot find manifest #{manifest_path}. " \
      'Have you run Webpack or is the webpack-dev-server running?'
  end

  def refresh
    @data = load
  end

  # Returns the entry points for the given entry pack `name`. By default this will return all entry
  # points in a pack regardless of type. If the `type` argument is given, only the entry points with
  # that type will be returned.
  def lookup_entry(name, type = nil)
    points = find('entrypoints')
    pack = points["#{name}/index.entry"] || points["#{name}.entry"]
    pack = pack[manifest_type(type)] if type
    pack
  end

  def lookup_entry!(name, type = nil)
    lookup_entry(name, type) || handle_missing_entry(name)
  end

  # Computes the relative path for a given Frails asset using manifest.json. If no asset is found,
  # returns nil.
  #
  # Example:
  #   Frails.manifest.lookup('calendar.js') # => "/frails/calendar.js"
  def lookup(name, type)
    # When the entrypoints key is not present in the manifest, or the name is not found in the
    # entrypoints hash, it will raise a NoMethodError. If this happens, we should try to lookup a
    # single instance of the pack based on the given name.
    entry_type = manifest_type(type)
    entry_name = manifest_name(name, entry_type)

    # Lookup the entrypoint in the entrypoints of the manifest
    find('entrypoints')[entry_name][entry_type]
  rescue NoMethodError
    # Lookup a single instance of the file.
    find full_pack_name(name, type)
  end

  # Like lookup, except that if no asset is found, raises a Frails::Manifest::MissingEntryError.
  def lookup!(name, type)
    lookup(name, type) || handle_missing_entry(name)
  end

  def read!(name, type)
    sources = *lookup!(name, type)
    sources.map do |path|
      yield path, read_source(path)
    end
  end

  def read(name, type)
    sources = *lookup(name, type)
    sources.map do |path|
      yield path, read_source(path)
    end
  end

  private

    def read_source(path)
      unless Frails.dev_server.running?
        host = ActionController::Base.helpers.compute_asset_host
        new_path = host && path.start_with?(host) ? path.delete_prefix(host) : path
        return Rails.public_path.join(new_path.gsub(%r{^\/}, '')).read
      end

      begin
        URI.open("http://#{Frails.dev_server.host_with_port}#{path}").read
      rescue OpenURI::HTTPError
        handle_missing_entry path
      end
    end

    def load
      manifest_path.exist? ? JSON.parse(manifest_path.read) : {}
    end

    def data
      if Rails.env.production?
        @data ||= load
      else
        refresh
      end
    end

    def handle_missing_entry(name)
      raise Frails::Manifest::MissingEntryError, "Frails can't find #{name} in #{manifest_path}."
    end

    def find(name)
      data[name.to_s].presence
    end

    def full_pack_name(name, type)
      return name unless File.extname(name.to_s).empty?

      "#{name}.#{manifest_type(type)}"
    end

    # Strips of the file extension of the given `name`, because in the manifest hash the entrypoints
    # are defined by their pack name without the extension. When the user provides a name with a
    # file extension, we want to try to strip it off.
    def manifest_name(name, type)
      return name if File.extname(name.to_s).empty?

      File.join File.dirname(name), File.basename(name, type)
    end

    def manifest_type(type)
      case type
      when :javascript then 'js'
      when :stylesheet then 'css'
      else type.to_s
      end
    end
end
