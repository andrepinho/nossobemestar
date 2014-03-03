# coding: utf-8

class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :detect_region
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
      if region = (Region.find_by_id(cookies[:current_region_id]) || Region.closest_to(current_coordinates))
        redirect_to url_for(params.merge(subdomain: region.subdomain)), notice: "Você está no portal <strong>#{region.name}.</strong> Se preferir, escolha outra região abaixo.".html_safe
      elsif request.subdomain == "www"
        @url_for_subdomain = url_for(params.merge(subdomain: "{subdomain}"))
        return render nothing: true, layout: "no_region"
      else
        redirect_to url_for(params.merge(subdomain: "www"))
      end
    end
  end

  def current_region
    @current_region ||= Region.find_by_subdomain(request.subdomain)
    if @current_region && @current_region.id != cookies[:current_region_id]
      cookies[:current_region_id] = {
        value: @current_region.id,
        expires: 1.year.from_now,
        domain: ( Rails.env.production? ? ".nossobemestar.com" : ".lvh.me" )
      }
    end
    @current_region
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
    devise_parameter_sanitizer.for(:sign_up) << :surname
    devise_parameter_sanitizer.for(:sign_up) << :region_id
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :surname
  end

end
