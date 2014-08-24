Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  resources :categories, only:[:show]
  get 'home', to: 'videos#index'
  resources :videos, only: [:index, :show] do 
    collection do 
      get 'search', to: 'videos#search' 
    end 
  end 
end
