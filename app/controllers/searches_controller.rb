class SearchesController < ApplicationController
  def index
    @query   = params[:q]
    @page    = params[:page] = params[:page] ? params[:page].to_i : 1

    if @query
      @results = SearchComposer.compose(@query, user: current_user, params: params)
      @search = current_user.searches.last
      @current_session = current_user.sessions.last
      @previous_query = @current_session.queries.last
      @previous_sessions = current_user.sessions.where.not(id: @current_session).last(5)
    end
  end

  def merge
    @search  = Search.find(params[:id])
    @session = Session.find(params[:session_id])

    @search.session = @session

    @search.save!

    render status: 200, nothing: true
  end

  def suggest
    @suggestions = Google::Suggest.for(params[:q]).first(10)

    render json: @suggestions.map { |suggestion| { value: suggestion, url: search_path(q: suggestion) }}
  end
end
