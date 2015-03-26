Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: "custom_applications", token_info: "custom_token_info"
  end
  root 'page#index'
  get :me, to: 'me#show'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations" }

  resources :users, except: [:create] do
    put :admin
    post :confirm
  end
  match 'users/me' => 'users#show', via: :get
  match 'users/me' => 'users#update', via: :post

  resources :devices, except: [:destroy, :update, :edit] do
    put :claim
    put :unclaim
  end
end
