class HomeController < ApplicationController
  def index
    @sections = current_region.sections.distinct
  end
end
