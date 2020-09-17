# frozen_string_literal: true

module Frails::Helper
  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize

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
