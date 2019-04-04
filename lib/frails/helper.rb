# frozen_string_literal: true

module Frails::Helper
  def frails_instance
    Frails.instance
  end

  def javascript_pack_tag(*names, **options)
    javascript_include_tag(*sources_from_manifest_entries(names, :javascript), **options)
  end

  def stylesheet_pack_tag(*names, **options)
    stylesheet_link_tag(*sources_from_manifest_entries(names, :stylesheet), **options)
  end

  private

    def sources_from_manifest_entries(names, type)
      names.map { |name| frails_instance.manifest.lookup!(name, type: type) }.flatten
    end
end
