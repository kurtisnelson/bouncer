Rails.application.routes.draw do
  use_doorkeeper do
    controllers applications: "custom_applications", token_info: "custom_token_info"
  end
  root 'page#index'
  get :me, to: 'me#show'
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks", registrations: "users/registrations" }

  resources :users, except: [:create] do
    put :admin
    put :confirm
    get :confirm
    scope module: 'users' do
      get :reset, to: 'passwords#show'
      post :reset, to: 'passwords#update'
      collection do
        post :reset, to: 'passwords#index'
      end
    end
  end
  match 'users/me' => 'users#show', via: :get
  match 'users/me' => 'users#update', via: :patch

  resources :activations
  resources :units
end
