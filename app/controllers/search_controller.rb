class SearchController < ApplicationController
  def show
    @query = params[:id]
    @pg_search_documents = PgSearch.multisearch(@query).page(params[:page]).per(10)
  end
end
