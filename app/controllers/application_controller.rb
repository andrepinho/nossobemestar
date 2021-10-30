# coding: utf-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :remove_subdomain
  before_filter :detect_region
  helper_method :current_region, :namespace, :current_coordinates, :display_title!, :hide_title!, :display_title?, :display_newsletter_bait!, :display_newsletter_bait?, :default_region

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

  def display_newsletter_bait?
    @display_newsletter_bait
  end

  def display_newsletter_bait!
    @display_newsletter_bait = true
  end

  def url_for_subdomain(subdomain)
    if controller_name == "home" && action_name == "index"
      root_url(subdomain: subdomain)
    else
      url_for(params.merge(subdomain: subdomain))
    end
  end

  def remove_subdomain
    if request.subdomain.present?
      url = URI.parse(request.url).tap { |uri| uri.host = request.domain }.to_s
      redirect_to url
    end
  end

  def detect_region
    cookies[:current_region_id] ||= default_region.id
    @current_region ||= Region.find_by(id: cookies[:current_region_id])

    @current_region
  end

  def default_region
    Region.find_by(name: ENV['DEFAULT_REGION_NAME'])
  end

  def current_region
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
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :surname, :region_id, :newsletter])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :surname])
  end

  def require_region_admin
    unless current_user && current_user.admin?
      unless current_user && current_user.region_admin? && current_region && current_region == current_user.region
        return redirect_to root_url, :alert => "Você não possui as permissões necessárias para realizar esta ação."
      end
    end
  end

end
