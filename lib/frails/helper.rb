# frozen_string_literal: true

module Frails::Helper
  def render(options = {}, *locals, &block)
    sload_assets = respond_to?(:side_load_assets?) ? side_load_assets? : false

    case options
    when Hash
      in_rendering_context(options) do
        return view_renderer.render_component(self, options, &block) if options.key?(:component)

        options[:side_load_assets] = sload_assets
        if block_given?
          view_renderer.render_partial(self, options.merge(partial: options[:layout]), &block)
        else
          view_renderer.render(self, options)
        end
      end
    else
      if options.is_a?(Class) && options < Frails::Component::Base
        return view_renderer.render_component(self, { component: options, locals: locals }, &block)
      end

      view_renderer.render_partial(self, side_load_assets: sload_assets, partial: options,
                                         locals: locals.extract_options!, &block)
    end
  end

  def javascript_pack_tag(*names, **options)
    return if Rails.env.test?

    @included_javascripts ||= []

    soft_lookup = options.delete(:soft_lookup) { false }
    sources = sources_from_manifest_entries(names, :javascript, manifest: options.delete(:manifest),
                                                                soft_lookup: soft_lookup)

    # Make sure that we don't include an asset that has already been included.
    sources -= @included_javascripts
    sources.compact!

    # Concatenate the sources to be included to those already included.
    @included_javascripts.concat sources

    sources.empty? ? nil : javascript_include_tag(*sources, **options)
  end

  def stylesheet_pack_tag(*names, **options)
    return if Rails.env.test?

    soft_lookup = options.delete(:soft_lookup) { false }
    sources = sources_from_manifest_entries(names, :stylesheet, manifest: options.delete(:manifest),
                                                                soft_lookup: soft_lookup)

    sources.compact!
    stylesheet_link_tag(*sources, **options)
  end

  def image_pack_tag(name, **options)
    return if Rails.env.test?

    image_tag(pack_path("images/#{name}", manifest: options.delete(:manifest)), **options)
  end

  def pack_path(name, type: nil, manifest: nil)
    manifest_manager[manifest].lookup! name, type: type
  end

  # Include the entry points for the given entry pack `name`.
  #
  # An entry pack is made up of one or more entry points in the manifest, and can be a mix of JS and
  # CSS entry points. Including an entry pack will therefore include all entry points in that pack.
  # This helper will create an HTML script tag for each JS file, and a stylesheet link tag for each
  # CSS file in the pack. All tags will be stored in an identifier courtesy of Rails `content_for`
  # helper; JS in a `:js` identifier and CSS in `:css`. These can then be rendered by yielding these
  # identifiers in your layouts.
  #
  # Examples:
  #   include_entry_pack 'application'
  #
  # Only the entry pack name should be given, without the file type, and without the `.entry`
  # suffix.
  #
  # If the pack name is a directory containing an "index.entry.*" file, that index file will be
  # included. So if you have `app/assets/admin/index.entry.js`, you can include it with
  # `include_entry_pack 'admin'`, instead of `include_entry_pack 'admin/index'`.
  #
  # You can optionally pass the `:manifest` named argument to specify the manifest to use. This
  # defaults to the value of `Frails.manifest_path`.
  #
  # Returns nil.
  def include_entry_pack(name, manifest: nil)
    manifest_manager[manifest].lookup_entry!("assets/#{name}").each do |type, points|
      if type == 'js'
        content_for type.to_sym, javascript_include_tag(*points, skip_pipeline: true)
      elsif type == 'css'
        content_for type.to_sym, stylesheet_link_tag(*points, skip_pipeline: true)
      end
    end
  end

  # Same as `include_entry_pack`, but will instead return the tags instead of storing them in a
  # `content_for` block.
  def entry_pack_tags(name, manifest: nil)
    manifest_manager[manifest].lookup_entry!("assets/#{name}").map do |type, points|
      if type == 'js'
        javascript_include_tag(*points, skip_pipeline: true)
      elsif type == 'css'
        stylesheet_link_tag(*points, skip_pipeline: true)
      end
    end
  end

  # Returns a javascript include tag for each entry point in the given entry pack `name`.
  #
  # Only the entry pack name should be given, without the file type, and without the `.entry`
  # suffix.
  #
  # If the pack name is a directory containing an "index.entry.*" file, that index file will be
  # included. So if you have `app/assets/admin/index.entry.js`, you can include it with
  # `javascript_entry_pack_tag 'admin'`, instead of `javascript_entry_pack_tag 'admin/index'`.
  #
  # You can optionally pass the `:manifest` named argument to specify the manifest to use. This
  # defaults to the value of `Frails.manifest_path`.
  #
  # Raises MissingManifestError if the entry point is not found.
  def javascript_entry_pack_tag(name, manifest: nil)
    points = manifest_manager[manifest].lookup_entry!("assets/#{name}", :js)
    javascript_include_tag(*points, skip_pipeline: true)
  end

  # Returns a stylesheet link tag for each entry point in the given entry pack `name`.
  #
  # Only the entry pack name should be given, without the file type, and without the `.entry`
  # suffix.
  #
  # If the pack name is a directory containing an "index.entry.*" file, that index file will be
  # included. So if you have `app/assets/admin/index.entry.css`, you can include it with
  # `stylesheet_entry_pack_tag 'admin'`, instead of `stylesheet_entry_pack_tag 'admin/index'`.
  #
  # You can optionally pass the `:manifest` named argument to specify the manifest to use. This
  # defaults to the value of `Frails.manifest_path`.
  #
  # Raises MissingManifestError if the entry point is not found.
  def stylesheet_entry_pack_tag(name, manifest: nil)
    points = manifest_manager[manifest].lookup_entry!("assets/#{name}", :css)
    stylesheet_link_tag(*points, skip_pipeline: true)
  end

  # Returns the entry asset path for the given `name`. A type is required, and is either derived
  # from the file extension or explicitly stated by the `:type` argument. If both are given, the
  # `:type` argument is used. The '*.entry.*' part of the name is not required. So both 'app.js' and
  # 'app.entry.js' will return the same asset.
  #
  # You can optionally pass the `:manifest` named argument to specify the manifest to use. This
  # defaults to the value of `Frails.manifest_path`.
  #
  # Examples:
  #   asset_entry_path 'application.js'
  #   asset_entry_path 'admin.entry.css'
  #   asset_entry_path 'user', type: :css
  #
  # Returns ?
  def asset_entry_path(name, type: nil, manifest: nil)
    if type.nil?
      type = File.extname(name.to_s)
      if type.blank? || type == 'entry'
        raise ArgumentError, 'File type is required either as part of the `name` or explicitly ' \
                             'as the `:type` argument.'
      end
    end

    manifest_manager[manifest].lookup! "assets/#{name}.entry", type
  end

  # Maps asset types to public directory.
  ASSET_PUBLIC_DIRECTORIES = {
    image: '/images'
  }.freeze

  def compute_asset_path(source, options = {})
    pp source, options
    dir = ASSET_PUBLIC_DIRECTORIES[options[:type]] || ''
    pp manifest_manager[options[:manifest]].lookup! File.join(Frails.public_output_path, dir, source), options[:type]
    File.join(dir, source)
  end

  private

    def sources_from_manifest_entries(names, type, manifest: nil, soft_lookup: false)
      names.map do |name|
        if soft_lookup
          manifest_manager[manifest].lookup name, type: type
        else
          manifest_manager[manifest].lookup! name, type: type
        end
      end.flatten
    end

    def manifest_manager
      Frails.manifest
    end
end
