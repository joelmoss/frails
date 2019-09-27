# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'pages#home'
  get 'about' => 'pages#about'
  get 'nav' => 'pages#nav'
  get 'angels' => 'pages#angels'
  get 'child' => 'pages#child'
end
