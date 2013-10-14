class HomeController < ApplicationController
  def index
    @sections = Section.all
  end
end
