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
    	@region_south = Region.where(group: 'Sul').order(:name)
      @region_north = Region.where(group: 'Norte').order(:name)
      @region_midwest = Region.where(group: 'Centro-Oeste').order(:name)
      @region_south_west = Region.where(group: 'Sudeste').order(:name)
      @region_northeast = Region.where(group: 'Nordeste').order(:name)
    	render :layout => false
    end
  end
  def email
    redirect_to root_path, notice: 'Obrigado por seu cadastro. Para concluir o seu cadastro, confirme em seu email.'
  end
end
