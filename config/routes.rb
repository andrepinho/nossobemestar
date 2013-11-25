Portal::Application.routes.draw do

  devise_for :users
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

  root 'home#index'

end
