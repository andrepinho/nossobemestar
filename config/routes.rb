Portal::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  resources :regions
  resources :posts
  resources :sections do
    get 'highlighted', on: :collection
  end
  resources :events do
    get 'admin', on: :collection
  end
  resources :services do
    get 'admin', on: :collection
  end

  root 'home#index'

end
