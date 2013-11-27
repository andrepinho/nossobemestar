class HomeController < ApplicationController
  def index
    hide_title!
    @sections = Section.order(:ordering).all
    @posts = Post.visible.home_page
  end

  def no_region
  	@regions = Region.all
  	render :layout => false
  end
end
