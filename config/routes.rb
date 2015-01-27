Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: "custom_applications"
  end
  root 'page#index'
  get :me, to: 'me#show'
  post :me, to: 'me#update'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :devices do
    put :remove
  end
end
