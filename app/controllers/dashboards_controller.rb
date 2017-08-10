class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  def index

  end

  def set_keywords

    @key = dashboard_params[:key]

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])

    $redis.del(@key)

    StreamWorker.perform_async(10, @keywords, @key, 0)

    respond_to do |format|
      format.js
    end

  end

  def get_tweets

    @tweets = []

    @key = dashboard_params[:key]

    tweets = $redis.lrange(@key, 0, 10)
    #$redis.del(@key)
    $redis.ltrim(@key, 10, $redis.llen(@key) )

    @keywords = $redis.get(@key + "-topics")

    tweets.each do |tweet|
      json_tweet = JSON.load(tweet)
      @tweets.push(FrontEndTweet.new(json_tweet[0], json_tweet[1]))
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
