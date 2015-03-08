class SearchesController < ApplicationController
  def index
    @query   = params[:q]
    @page    = params[:page] = params[:page] ? params[:page].to_i : 1

    if @query
      @results = SearchComposer.compose(@query, user: current_user, params: params)
      @search = current_user.searches.last
      @current_session = current_user.sessions.last
      @previous_sessions = current_user.sessions.where.not(id: @current_session).order(created_at: :desc).last(6)
      @previous_session = @previous_sessions.first
      @other_sessions = @previous_sessions - [@previous_session]
      @previous_query = @previous_session.searches.order(:created_at).last.query if @previous_session
    end
  end

  def merge
    @search  = Search.find(params[:id])
    @session = Session.find(params[:session_id])

    if @search.session.searches.count == 1 && @session != @search.session
      @search.session.destroy!
    end

    @search.session = @session
    @search.annotated_at = Time.now

    @search.save!

    render status: 200, nothing: true
  end

  def suggest
    @suggestions = Google::Suggest.for(params[:q]).first(10)

    render json: @suggestions.map { |suggestion| { value: suggestion, url: search_path(q: suggestion) }}
  end
end
