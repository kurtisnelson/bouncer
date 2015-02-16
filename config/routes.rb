Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: "custom_applications", token_info: "custom_token_info"
  end
  root 'page#index'
  get :me, to: 'me#show'
  post :me, to: 'me#update'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :users do
    put :admin
    collection do
      get :me, to: 'me#show'
      post :me, to: 'me#update'
    end
  end

  resources :devices do
    put :remove
  end
end
