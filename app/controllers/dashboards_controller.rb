class DashboardsController < ApplicationController

  def index

  end

  def set_keywords

    if TwitterService.thread_is_running?
      puts "Stopping thread"
      TwitterService.stop_thread
    end

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])
    respond_to do |format|
      #need to put filters up, show realtime tweets.
      format.js
    end

  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:keywords)
  end


end