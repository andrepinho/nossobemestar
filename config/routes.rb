Portal::Application.routes.draw do

  get "static_pages/survey"
  get "static_pages/about"
  devise_for :users, controllers: { :passwords => "passwords", :omniauth_callbacks => "users/omniauth_callbacks" }
  mount Ckeditor::Engine => '/ckeditor'

  resources :regions
  resources :posts
  resources :sections do
    collection do
      get 'highlighted'
      get 'local'
    end
  end
  resources :events do
    get 'admin', on: :collection
  end
  resources :services do
    get 'admin', on: :collection
  end
  resources :users, except: [:show, :new, :create] do
    member do
      get 'services'
      get 'events'
    end
  end
  resources :home, only: [:index] do
    collection do
      get 'email'
      post 'set_highlighted'
    end
  end
  resources :ads, except: [:show] do
    member do
      get 'click'
    end
  end
  root 'home#index'

end
