# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about' => 'pages#about'
  get 'partial_no_css' => 'pages#partial_no_css'
  get 'partial_collection' => 'pages#partial_collection'
  get 'no_side_load' => 'no_side#index'
  get 'components/template_only' => 'components#template_only'
  get 'components/template_with_css' => 'components#template_with_css'
  get 'components/with_children' => 'components#with_children'
end
