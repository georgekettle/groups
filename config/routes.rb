Rails.application.routes.draw do
  resources :group_members
  resources :profiles
  resources :groups do
    resources :channels, only: [:new, :create, :index]
  end
  resources :channels, only: [:edit, :update, :destroy, :show] do
    resources :messages, only: [:create]
  end

  resources :messages, only: [:update, :destroy]

  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
