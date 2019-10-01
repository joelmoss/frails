# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about' => 'pages#about'
  get 'no_side_load' => 'no_side#index'
end
