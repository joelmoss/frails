# frozen_string_literal: true

class ComponentsController < ApplicationController
  before_action :set_age

  private

    def set_age
      @age = 42
    end
end
