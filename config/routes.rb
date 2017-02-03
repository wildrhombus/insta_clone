Rails.application.routes.draw do
  #devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  devise_for :users, controllers: {
      sessions: 'users/sessions'
  }

  root "posts#index"

  resources :posts
end
