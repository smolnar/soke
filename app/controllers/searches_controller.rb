class SearchesController < ApplicationController
  def index
    @query   = params[:q]
    @page    = params[:page] ? params[:page].to_i : 1
    @results = SearchComposer.compose(@query, page: @page) if @query
  end

  def suggest
    @suggestions = Google::Suggest.for(params[:q]).first(10)

    render json: @suggestions.map { |suggestion| { value: suggestion, url: search_path(q: suggestion) }}
  end
end
