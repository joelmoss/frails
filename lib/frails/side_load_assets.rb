# frozen_string_literal: true

module Frails::SideLoadAssets
  extend ActiveSupport::Concern

  included do
    class_attribute :_side_load_assets, default: false
  end

  class_methods do
    def side_load_assets
      self._side_load_assets = true
    end
  end

  # Add _side_load_assets flag to the options hash, which will be available in TemplateRenderer,
  # allowing us control if views/layouts are side loaded.
  def _normalize_options(options)
    super
    options[:side_load_assets] = _side_load_assets
    options
  end
end
