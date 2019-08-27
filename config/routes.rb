Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users, controllers: { omniauth_callbacks: 'callbacks' } 

  resources :users, only: [:show, :index]

  resources :posts

  resources :comments

  resources :likes

  resources :friendships

  get :pending_requests, to: 'friendships#pending'
end
