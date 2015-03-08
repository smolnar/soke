class ResultsController < ApplicationController
  def show
    @result = Result.find(params[:id])

    @result.clicked_at = Time.now
    @result.save!

    redirect_to @result.page.url
  end
end
