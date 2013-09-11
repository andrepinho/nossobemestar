class SessionsController < ApplicationController
  before_action :set_post, only: [:show]

  def index
    @sessions = Session.all
  end
  
  def set_post
      @session = Session.find(params[:id])
  end
end
