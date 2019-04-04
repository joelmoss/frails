# frozen_string_literal: true

class Frails::Manifest
  class MissingEntryError < StandardError; end

  def refresh
    @data = load
  end

  # Computes the relative path for a given Frails asset using manifest.json. If no asset is found,
  # returns nil.
  #
  # Example:
  #   Frails.manifest.lookup('calendar.js') # => "/packs/calendar-1016838bab065ae1e122.js"
  def lookup(name, type: nil)
    # When using SplitChunks or RuntimeChunks the manifest hash will contain an extra object called
    # "entrypoints". When the entrypoints key is not present in the manifest, or the name is not
    # found in the entrypoints hash, it will raise a NoMethodError. If this happens, we should try
    # to lookup a single instance of the pack based on the given name.
    manifest_pack_type = manifest_type(type)
    manifest_pack_name = manifest_name(name, manifest_pack_type)

    # Lookup the pack in the entrypoints of the manifest
    find('entrypoints')[manifest_pack_name][manifest_pack_type]
  rescue NoMethodError
    # Lookup a single instance of the pack.
    find full_pack_name(name, type)
  end

  # Like lookup, except that if no asset is found, raises a Frails::Manifest::MissingEntryError.
  def lookup!(name, type: nil)
    lookup(name, type: type) || handle_missing_entry(name)
  end

  def manifest_path
    @manifest_path ||= Rails.root.join('public', 'packs', 'manifest.json')
  end

  private

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
      raise Frails::Manifest::MissingEntryError, missing_file_from_manifest_error(name)
    end

    def find(name)
      data[name.to_s].presence
    end

    def full_pack_name(name, type)
      return name unless File.extname(name.to_s).empty?

      "#{name}.#{manifest_type(type)}"
    end

    # The `manifest_name` method strips of the file extension of the name, because in the
    # manifest hash the entrypoints are defined by their pack name without the extension.
    # When the user provides a name with a file extension, we want to try to strip it off.
    def manifest_name(name, type)
      return name if File.extname(name.to_s).empty?

      File.basename(name, type)
    end

    def manifest_type(type)
      case type
      when :javascript then 'js'
      when :stylesheet then 'css'
      else type.to_s
      end
    end

    def missing_file_from_manifest_error(bundle_name)
      <<~MSG
        Frails can't find #{bundle_name} in #{manifest_path}. Your manifest contains:
        #{JSON.pretty_generate(@data)}
      MSG
    end
end
