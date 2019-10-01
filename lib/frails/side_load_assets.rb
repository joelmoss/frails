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
end
