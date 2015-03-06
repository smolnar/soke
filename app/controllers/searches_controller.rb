class SearchesController < ApplicationController
  def index
    @query = params[:q]
  end

  def suggest
    @suggestions = Google::Suggest.for(params[:q]).first(10)

    render partial: 'suggestions'
  end
end
