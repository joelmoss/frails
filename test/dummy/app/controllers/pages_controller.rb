# frozen_string_literal: true

class PagesController < ApplicationController
  # self.side_load_assets = true

  def show
    render params[:page]
  end
end
