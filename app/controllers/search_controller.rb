class SearchController < ApplicationController
  def index
    return redirect_to :root unless params[:query].present?
    redirect_to search_path(params[:query])
  end
  def show
    @query = params[:id]
    @pg_search_documents = PgSearch.multisearch(@query).page(params[:page]).per(10)
  end
end
