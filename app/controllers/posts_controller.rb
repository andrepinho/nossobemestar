# coding: utf-8

class PostsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:show]
  authorize_resource

  def index
    @posts = Post.all.order(sort_column + " " + sort_direction).page(params[:page]).per(10)
    @posts = @posts.search(params[:search]) if params[:search].present?
  end

  def show
    if @post.section
      @section = @post.section
      @related = @section.posts.where("region_id IS NULL").order('RANDOM()').limit(3)
    end
    hide_title!
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    @post = Post.new(post_params)
    respond_to do |format|
      if @post.save
        format.html { redirect_to posts_path, notice: 'Post criado com sucesso.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to posts_path, notice: 'Post atualizado com sucesso.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_path, notice: 'Post excluido com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:region_id, :title, :subtitle, :content, :published_at, :author, :front_title, :front_content, :ordering,:home_ordering, :image, :image_credit, :image_caption, :section_id, :highlighted, :original_title)
    end

    def sort_column
      params[:sort] || "published_at"
      Post.column_names.include?(params[:sort]) ? params[:sort] : "published_at"
    end

    def sort_direction
      params[:direction] || "decs"
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end