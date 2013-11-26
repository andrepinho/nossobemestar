# coding: utf-8

class UsersController < ApplicationController
  before_action :set_user, only: [:edit, :update, :destroy, :events, :services]
  before_filter :authenticate_user!
  authorize_resource

  def index
    @users = User.all
  end

  def events
    @events = @user.events
  end

  def services
    @services = @user.services
  end

  def edit
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to users_path, notice: 'Usuário atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_path, notice: 'Usuário excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :admin)
  end
end
