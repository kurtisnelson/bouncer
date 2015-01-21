Rails.application.routes.draw do
  root 'page#index'

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
