class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  config.autoload_paths += %W(#{config.root}/app/models/ckeditor)
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
