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

    last_tweets = nil
    @single_tweet = []

    @tweets = []

    if TwitterService.thread_is_running?
      puts "In get tweets"
      puts "Twitter service thread is running"
      last_tweets = TwitterService.get_last_tweets

      last_tweets.each do |tweet|
        @single_tweet.push(tweet.attrs.to_json)
        @tweets.push(FrontEndTweet.new(tweet.attrs))

        puts "Tweet first: #{@tweets.first.inspect}"
        puts "Tweet first: #{@tweets.first.text}"

      end

     @single_tweet = last_tweets.first.attrs.to_json #last_tweets.map(&:attrs).first
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