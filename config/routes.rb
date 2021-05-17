Rails.application.routes.draw do
  resources :notifications, only: [:index]

  resources :profiles do
    collection do
      get :search
    end
  end

  resources :groups do
    resources :channels, only: [:new, :create, :index]
    resources :group_members, only: [:new, :create, :index]
  end

  resources :group_members, only: [:edit, :update, :destroy]

  resources :channels, only: [:edit, :update, :destroy, :show] do
    resources :messages, only: [:create]
    resources :channel_members, only: [:new, :create, :index] do
      collection do
        get :search
      end
    end
    collection do
      get :all
    end
  end

  resources :channel_members, only: [:edit, :update, :destroy]

  resources :messages, only: [:update, :destroy]

  devise_for :users

  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
