# coding: utf-8

class HomeController < ApplicationController
  def index
    hide_title!
    @sections = Section.order(:ordering).all
    @posts = Post.visible.home_page
    @events = ((current_region && current_region.events ) || Event.where("region_id IS NULL")).where("ends_at > current_timestamp").order('RANDOM()').limit(3)
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order('RANDOM()').limit(3)
  end
  def email
    redirect_to root_path, notice: 'Obrigado por seu cadastro. Por favor, confirme a sua inscrição em seu email.'
  end
end
