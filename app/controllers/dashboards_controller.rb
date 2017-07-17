class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  def index

  end

  def set_keywords

    @key = dashboard_params[:key]
    puts @key

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])
    Resque.enqueue(Streamer,10, *@keywords, @key)

    respond_to do |format|
      format.js
    end

  end

  def get_tweets

    @tweets = []

    key = dashboard_params[:key]

    if DataCache.data.exists(key)
      tweets = JSON.load(DataCache.get(key))

      keywords = DataCache.data.get(key + "-topics")
      Resque.enqueue( Streamer,10, *keywords, key)

      tweets.each do |tweet|
        @tweets.push(FrontEndTweet.new(tweet[0], tweet[1]))
      end

    end

    respond_to do |format|
      format.js
    end

  end

  private

    def dashboard_params
      params.require(:dashboard).permit(:keywords, :key)
    end

end
