Rails.application.routes.draw do
  devise_for :users
  #devise_for :users
  root "posts#index"

  resources :posts
end
