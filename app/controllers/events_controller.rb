class EventsController < ApplicationController

  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :require_region_admin, only: [:admin]
  authorize_resource

  def index
    hide_title!
    @events = ((current_region && current_region.events ) || Event.where("region_id IS NULL")).by_relevance.page(params[:page]).per(30)
    @events = @events.search(params[:search]).by_relevance if params[:search].present?
  end

  def admin
    @events = ((current_region && current_region.events ) || Event.where("region_id IS NULL")).by_relevance
    @events = @events.search(params[:search]) if params[:search].present?
    respond_to do |format|
      format.html do
        @events = @events.page(params[:page]).per(10)
      end
      format.csv { send_data @events.to_csv }
    end
  end

  def show
    hide_title!
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    respond_to do |format|
      if @event.save
        format.html { redirect_to event_path(@event), notice: 'Seu evento foi criado com sucesso!' }
        format.json { render action: 'show', status: :created, location: @event }
      else
        format.html { render action: 'new' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_path(@event), notice: 'Seu evento foi atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_path, notice: 'Evento excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:name, :starts_at, :ends_at, :image, :description, :url, :address, :email, :phone_number, :region_id)
  end
end
