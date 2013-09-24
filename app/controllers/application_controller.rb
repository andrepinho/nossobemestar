class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_section instead.
  protect_from_forgery with: :exception
  before_filter :detect_region
  helper_method :current_region
  private
  def detect_region
    redirect_to root_url(subdomain: Region.first.subdomain) unless current_region
  end
  def current_region
    @current_region ||= (Region.find_by_subdomain(request.subdomain) || Region.create(name: "Porto Alegre", subdomain: "portoalegre"))
  end
  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == "admin" && Digest::MD5.hexdigest(password) == "605593df6a4323da215d22838c527489"
    end
  end

end