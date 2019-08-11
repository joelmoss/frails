# frozen_string_literal: true

module Frails::Helper
  def javascript_pack_tag(*names, **options)
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
    soft_lookup = options.delete(:soft_lookup) { false }
    sources = sources_from_manifest_entries(names, :stylesheet, manifest: options.delete(:manifest),
                                                                soft_lookup: soft_lookup)

    sources.compact!
    stylesheet_link_tag(*sources, **options)
  end

  def image_pack_tag(name, **options)
    image_tag(pack_path("images/#{name}", manifest: options.delete(:manifest)), **options)
  end

  def pack_path(name, type: nil, manifest: nil)
    manifest_manager[manifest].lookup! name, type: type
  end

  def side_load_assets(layout: nil, manifest: nil)
    # Layout
    path = "views/layouts/#{layout || layout_name}"
    content_for :foot, javascript_pack_tag(path, manifest: manifest, soft_lookup: true)
    render_css_asset path, manifest: manifest

    # View
    path = "views/#{rendered_view_path}"
    content_for :foot, javascript_pack_tag(path, manifest: manifest, soft_lookup: true)
    render_css_asset path, manifest: manifest
  end

  private

    # Render CSS assets for the given `asset_path`, by reading the content of each asset and
    # inserting the content in to the page head (inline styles).
    def render_css_asset(asset_path, manifest: nil)
      manifest_manager[manifest].read(asset_path, :stylesheet) do |path, source|
        content_for :page_styles, content_tag(:style, source, { data: { href: path } }, false)
      end
    end

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
