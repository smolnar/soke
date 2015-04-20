class SessionsController < ApplicationController
  def index
    @sessions = current_user.sessions.order(created_at: :desc)
  end

  def update
    @session = Session.find(params[:session_id])

    @session.update_attributes!(update_params)

    @session.destroy unless @session.queries.any?

    # redirect_to sessions_path
    render status: 200, nothing: true
  end

  private

  def update_params
    params.require(:session).permit(searches_attributes: [:id, :session_id])
  end
end
