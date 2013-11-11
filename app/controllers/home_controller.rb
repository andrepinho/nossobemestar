class HomeController < ApplicationController
  def index
    @sections = Section.order(:ordering).all
    @posts = Post.visible.home_page
  end
end
