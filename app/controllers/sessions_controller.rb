class SessionsController < ApplicationController
  def index
    @sessions = current_user.sessions.order(created_at: :desc)
  end
end
