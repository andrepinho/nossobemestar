# coding: utf-8

class ServicesController < ApplicationController
  before_action :set_service, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  authorize_resource

  def index
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).page(params[:page]).per(9)
    @services = @services.search(params[:search]) if params[:search].present?
  end

  def admin
    @services = ((current_region && current_region.services ) || Service.where("region_id IS NULL")).page(params[:page]).per(10)
  end

  def show
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
        format.html { redirect_to admin_services_path, notice: 'Serviço atualizado com sucesso.' }
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
      format.html { redirect_to admin_services_path, notice: 'Serviço excluido com sucesso.' }
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
