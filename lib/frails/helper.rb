# frozen_string_literal: true

module Frails::Helper
  def render(options = {}, locals = {}, &block)
    case options
    when Hash
      if Rails::VERSION::MAJOR >= 6
        in_rendering_context(options) do |_renderer|
          if block_given?
            # MONKEY PATCH! simply renders the component with the given block.
            return view_renderer.render_component(self, options, &block) if options.key?(:component)

            view_renderer.render_partial(self, options.merge(partial: options[:layout]), &block)
          else
            view_renderer.render(self, options)
          end
        end
      else
        if block_given?
          # MONKEY PATCH! simply renders the component with the given block.
          return view_renderer.render_component(self, options, &block) if options.key?(:component)

          view_renderer.render_partial(self, options.merge(partial: options[:layout]), &block)
        else
          view_renderer.render(self, options)
        end
      end
    else
      view_renderer.render_partial(self, partial: options, locals: locals, &block)
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
