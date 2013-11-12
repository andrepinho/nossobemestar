# coding: utf-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :detect_region
  helper_method :current_region, :namespace, :current_coordinates

  private

  def detect_region
    unless current_region
      if region = Region.closest_to(current_coordinates || [request.location.latitude, request.location.longitude])
        redirect_to root_url(subdomain: region.subdomain), notice: "Nós detectamos que nosso afiliado mais próximo de você está em #{region.name}. Se preferir, escolha outra região abaixo."
      elsif request.subdomain != "www"
        redirect_to root_url(subdomain: "www")
      end
    end
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

  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && Digest::MD5.hexdigest(password) == "605593df6a4323da215d22838c527489"
    end
  end

  def namespace
    names = self.class.to_s.split('::')
    return "null" if names.length < 2
    names[0..(names.length-2)].map(&:downcase).join('_')
  end

end
