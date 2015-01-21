Rails.application.routes.draw do
  use_doorkeeper
  root 'page#index'
  get :me, to: 'tokens#me'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
end
