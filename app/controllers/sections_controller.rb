# coding: utf-8

class SectionsController < ApplicationController
  before_action :set_section, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show, :highlighted, :local]
  authorize_resource

  def index
    @sections = Section.order(:ordering)
  end

  def show
    @page = params[:page]
    @highlighted = Section.find(params[:id]).posts.highlighted.where("region_id IS NULL")
    @section = Section.find(params[:id])
    @posts = @section.posts.not_highlighted.order("published_at desc").where("region_id IS NULL").page(params[:page]).per(9)
  end

  def new
    @section = Section.new
  end

  def edit
  end

  def create
    @section = Section.new(section_params)
    respond_to do |format|
      if @section.save
        format.html { redirect_to sections_path, notice: 'Seção criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @section }
      else
        format.html { render action: 'new' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update(section_params)
        format.html { redirect_to sections_path, notice: 'Seção atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @section.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @section.destroy
    respond_to do |format|
      format.html { redirect_to sections_path, notice: 'Seção excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  def highlighted
    @page = params[:page]
    @highlighted = Post.visible.home_page.where("region_id IS NULL")
    @posts = Post.not_home_page.where(highlighted: true).order("published_at desc").where("region_id IS NULL").page(params[:page]).per(9)
  end

  def local
    return redirect_to root_path, alert: 'Você precisa estar em uma região para ver notícias locais.' unless current_region
    @posts = current_region.posts.visible.order("published_at desc").page(params[:page]).per(9)
    @ads = Ad.for(current_region, :da, quantity: 3)
    @events = @ads.map(&:event) rescue []
    @events += ((current_region && current_region.events ) || Event.where("region_id IS NULL")).where("ends_at > current_timestamp").order('RANDOM()').limit(3 - @events.length)
    hide_title!
  end

  private

  def set_section
    @section = Section.find(params[:id])
  end

  def section_params
    params.require(:section).permit(:name, :color, :ordering)
  end

end
