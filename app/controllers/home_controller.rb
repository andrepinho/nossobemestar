# coding: utf-8

class HomeController < ApplicationController
  def index
    if @current_region.blank?
      redirect_to action: 'no_region'
    else
      hide_title!
      @sections = Section.order(:ordering).all
      @posts = Post.visible.home_page
      @events = ((current_region && current_region.events ) || Event.where("region_id IS NULL")).by_relevance.limit(3)
      @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order('RANDOM()').limit(3)
    end
  end

  def no_region
    if @current_region.present?
      redirect_to root_path
    else
    	@region_south = Region.where(group: 'Sul').order(:name)
      @region_north = Region.where(group: 'Norte').order(:name)
      @region_midwest = Region.where(group: 'Centro-Oeste').order(:name)
      @region_south_west = Region.where(group: 'Sudeste').order(:name)
      @region_northeast = Region.where(group: 'Nordeste').order(:name)
    	render :layout => false
    end
  end
  def email
    redirect_to root_path, notice: 'Obrigado por seu cadastro. Por favor, confirme a sua inscrição em seu email.'
  end
end
