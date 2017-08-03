class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  def index

  end

  def set_keywords

    @key = dashboard_params[:key]

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])


    #Sidekiq::Queue.new.clear

    $redis.del(@key)

    StreamWorker.perform_async(10, @keywords, @key, 0)

    respond_to do |format|
      format.js
    end

  end

  def get_tweets

    @tweets = []

    @key = dashboard_params[:key]

    if $redis.exists(@key)
      tweets = JSON.load($redis.get(@key))

      @keywords = $redis.get(@key + "-topics")

      StreamWorker.perform_async(10, @keywords, @key, 1)

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
