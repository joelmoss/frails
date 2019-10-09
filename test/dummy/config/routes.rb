# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about' => 'pages#about'
  get 'partial_no_css' => 'pages#partial_no_css'
  get 'partial_collection' => 'pages#partial_collection'
  get 'no_side_load' => 'no_side#index'

  get 'react' => 'react#index'
  get 'react/view_instance_vars' => 'react#view_instance_vars'

  get 'components/template_only' => 'components#template_only'
  get 'components/without_template' => 'components#without_template'
  get 'components/render_callbacks' => 'components#render_callbacks'
  get 'components/view_instance_vars' => 'components#view_instance_vars'
  get 'components/locals' => 'components#locals'
  get 'components/template_with_css' => 'components#template_with_css'
  get 'components/with_children' => 'components#with_children'
  get 'components/restricted_templates' => 'components#restricted_templates'
end
