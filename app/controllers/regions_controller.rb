# coding: utf-8

class RegionsController < ApplicationController
  before_action :set_region, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show]
  authorize_resource

  def index
    @regions = Region.all
  end

  def show
    redirect_to root_url(subdomain: @region.subdomain)
  end

  def new
    @region = Region.new
  end

  def edit
  end

  def create
    @region = Region.new(region_params)

    respond_to do |format|
      if @region.save
        format.html { redirect_to regions_path, notice: 'Região criada com sucesso.' }
        format.json { render action: 'show', status: :created, location: @region }
      else
        format.html { render action: 'new' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @region.update(region_params)
        format.html { redirect_to regions_path, notice: 'Região atualizada com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @region.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @region.destroy
    respond_to do |format|
      format.html { redirect_to regions_path, notice: 'Região excluida com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  def set_region
    @region = Region.find(params[:id])
  end

  def region_params
    params.require(:region).permit(:name, :subdomain, :latitude, :longitude, :background, :facebook, :group, :newsletter_id)
  end
end
