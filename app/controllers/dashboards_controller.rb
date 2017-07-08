class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

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

  def get_tweets

    @tweets = []

    if TwitterService.thread_is_running?
      puts "Twitter service thread is running"

      last_tweets = TwitterService.get_last_tweets

      last_tweets.each do |tweet|
        @tweets.push(FrontEndTweet.new(tweet[0].attrs, tweet[1]))

      end
      TwitterService.nullify_tweets
    else
      puts "Twitter service is not runnning.... Hm...."
    end

    respond_to do |format|
      format.js
    end


  end

  private

  def dashboard_params
    params.require(:dashboard).permit(:keywords)
  end


end