Rails.application.routes.draw do

  root 'posts#index'

  devise_for :users

  resources :users, only: [:show, :index]

  resources :posts

  resources :comments

  resources :likes

  resources :friendships, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
