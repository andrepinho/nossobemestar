# coding: utf-8

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :detect_region
  helper_method :current_region, :namespace

  private
  def detect_region
    unless current_region
      if region = Region.closest_to(request.location.latitude, request.location.longitude)
        flash[:notice] = "Nós detectamos que nosso afiliado mais próximo de você é o Nosso Bem Estar #{region.name}, por isto o redirecionamos para cá. Se preferir, escolha outra região abaixo."
        redirect_to root_url(subdomain: region.subdomain)
      elsif request.subdomain != "www"
        redirect_to root_url(subdomain: "www")
      end
    end
  end

  def current_region
    @current_region ||= Region.find_by_subdomain(request.subdomain)
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
