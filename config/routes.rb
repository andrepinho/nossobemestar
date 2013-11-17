Portal::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  resources :regions
  resources :posts
  resources :sections
  resources :events do
    get 'admin', on: :collection
  end

  root 'home#index'

end
