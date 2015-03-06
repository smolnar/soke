class SearchesController < ApplicationController
  before_action :setup_params, only: [:index]

  def index
    @query   = params[:q]
    @results = SearchComposer.compose(@query, page: params[:page]) if @query
  end

  def suggest
    @suggestions = Google::Suggest.for(params[:q]).first(10)

    render json: @suggestions.map { |suggestion| { value: suggestion, url: search_path(q: suggestion) }}
  end

  private

  def setup_params
    params[:page] ||= 1
  end
end
