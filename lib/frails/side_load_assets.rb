# frozen_string_literal: true

module Frails::SideLoadAssets
  extend ActiveSupport::Concern

  included do
    class_attribute :side_load_assets, default: false
    helper_method :side_load_assets?
  end

  # Add _side_load_assets flag to the options hash, which will be available in TemplateRenderer,
  # allowing us control if views/layouts are side loaded.
  def _normalize_options(options)
    super
    options[:side_load_assets] = side_load_assets
    options
  end
end
