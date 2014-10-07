Myflix::Application.routes.draw do
  root to: "pages#front"
  get 'home', to: 'videos#index'
  resources :videos, only: [:show] do 
    collection do 
      get 'search', to: 'videos#search' 
    end 
    resources :reviews, only: [:create]
  end 
  
  resources :users, only: [:create, :show]  
  get 'friends', to: "friendships#index", as: 'friends'
  resources :friendships, only:[:create, :destroy]
  get 'ui(/:action)', controller: 'ui'
  get 'register', to: "users#new"
  get 'sign_in', to: "sessions#new"
  get 'sign_out', to: "sessions#destroy"
  get 'forgot_password', to: "forgot_passwords#new"
  get 'forgot_password_confirmation', to: "forgot_passwords#confirm"
  get 'expired_token', to: 'password_resets#expired_token'
  get 'register/:token', to: 'users#new_with_invitation_token', as: 'register_with_token'

  resources :forgot_passwords, only: [:create]
  resources :password_resets, only: [:show, :create]
  resources :sessions, only: [:create]
  resources :queue_items, only: [:create, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
  resources :my_queue, to: "queue_items#index"
  resources :categories, only:[:show]
  resources :invitations, only: [:new, :create]
end
