# coding: utf-8

class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :require_region_admin, only: [:admin]
  authorize_resource

  def index
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order("created_at desc").page(params[:page]).per(9)
    @services = @services.search(params[:search]) if params[:search].present?
    @ads = Ad.for(current_region, :dg, quantity: 3)
    @ad_services = @ads.map(&:service) rescue []
    @ad_services += ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order('RANDOM()').limit(3 - @ad_services.length)
    hide_title!
  end

  def admin
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL"))
    @services = @services.search(params[:search]) if params[:search].present?
    respond_to do |format|
      format.html do
        @services = @services.page(params[:page]).per(10)
      end
      format.csv { send_data @services.to_csv }
    end
  end

  def show
    @ads = Ad.for(current_region, :dg, quantity: 3)
    @ad_services = @ads.map(&:service) rescue []
    @ad_services += ((current_region && current_region.services ) || Service.where("region_id IS NULL")).order('RANDOM()').limit(3 - @ad_services.length)
    hide_title!
  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    @service.user = current_user
    respond_to do |format|
      if @service.save
        format.html { redirect_to service_path(@service), notice: 'Seu serviço foi criado com sucesso!' }
        format.json { render action: 'show', status: :created, location: @service }
      else
        format.html { render action: 'new' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to service_path(@service), notice: 'Seu serviço foi atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_path, notice: 'Serviço excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  def set_service
    @service = Service.find(params[:id])
  end

  def service_params
    params.require(:service).permit(:name, :starts_at, :ends_at, :image, :description, :url, :address, :email, :phone_number, :region_id)
  end
end
