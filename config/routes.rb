Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:show, :index]

  resources :posts

  resources :comments

  resources :likes

  resources :friendships

  get :pending_requests, to: 'friendships#pending'
end
