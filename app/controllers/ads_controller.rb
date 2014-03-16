# coding: utf-8

class AdsController < ApplicationController

  before_action :set_region, only: [:edit, :update, :destroy]
  before_filter :authenticate_user!
  before_filter :require_region_admin
  authorize_resource

  def index
    @ads = current_region.ads.by_relevance
    @ads = @ads.search(params[:search]) if params[:search].present?
    respond_to do |format|
      format.html do
        @ads = @ads.page(params[:page]).per(10)
      end
    end
  end

  def new
    @ad = Ad.new
  end

  def edit
  end

  def create
    @ad = Ad.new(ad_params)
    @ad.region = current_region

    respond_to do |format|
      if @ad.save
        format.html { redirect_to ads_path, notice: 'Anúncio criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @ad }
      else
        format.html { render action: 'new' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ad.update(ad_params)
        format.html { redirect_to ads_path, notice: 'Anúncio atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ad.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ad.destroy
    respond_to do |format|
      format.html { redirect_to ads_path, notice: 'Anúncio excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_ad
    @ad = Ad.find(params[:id])
  end

  def ad_params
    params.require(:ad).permit(:code, :starts_at, :ends_at, :image, :url, :observations)
  end

end
