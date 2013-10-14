class HomeController < ApplicationController
  def index
    @sections = Section.all
    @posts = Post.visible.home_page
  end
end
