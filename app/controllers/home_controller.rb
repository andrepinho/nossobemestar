class HomeController < ApplicationController
  def index
    if @current_region.blank?
      redirect_to action: 'no_region'
    else
      hide_title!
      @sections = Section.order(:ordering).all
      @posts = Post.visible.home_page
    end
  end

  def no_region
    if @current_region.present?
      redirect_to root_path
    else
    	@regions = Region.all.order(:name)
    	render :layout => false
    end
  end
end
