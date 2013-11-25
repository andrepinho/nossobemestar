# coding: utf-8

class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :detect_region
  before_filter :set_current_user_region
  helper_method :current_region, :namespace, :current_coordinates, :display_title!, :hide_title!, :display_title?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Você não possui as permissões necessárias para realizar esta ação."
  end

  private

  def display_title?
    !@hide_title
  end

  def display_title!
    @hide_title = false
  end

  def hide_title!
    @hide_title = true
  end

  def detect_region
    unless current_region
      if current_coordinates && region = Region.closest_to(current_coordinates)
        redirect_to root_url(subdomain: region.subdomain), notice: "Nós detectamos que nosso afiliado mais próximo de você está em #{region.name}. Se preferir, escolha outra região abaixo."
      elsif request.subdomain != "www"
        redirect_to root_url(subdomain: "www")
      end
    end
  end

  def set_current_user_region
    return unless current_user && current_region
    current_user.update_attribute :region_id, current_region.id
  end

  def current_region
    @current_region ||= Region.find_by_subdomain(request.subdomain)
  end

  def current_coordinates
    if params[:latitude] && params[:longitude]
      session[:current_coordinates] = [params[:latitude], params[:longitude]]
    else
      session[:current_coordinates]
    end
  end

  def namespace
    names = self.class.to_s.split('::')
    return "null" if names.length < 2
    names[0..(names.length-2)].map(&:downcase).join('_')
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

end
