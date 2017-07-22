class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  def index

  end

  def set_keywords

    @key = dashboard_params[:key]

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])

    Sidekiq::Queue.new.clear

    DataCache.delete_key(@key)

    StreamWorker.perform_async(10, @keywords, @key, 0)
    #Resque.enqueue(Streamer,10, @keywords, @key, 0)

    respond_to do |format|
      format.js
    end

  end

  def get_tweets

    @tweets = []

    @key = dashboard_params[:key]

    if DataCache.exists(@key)
      tweets = JSON.load(DataCache.get(@key))
      @keywords = DataCache.get_topics(@key)

      StreamWorker.perform_async(10, @keywords, @key, 1)

      #Resque.enqueue( Streamer,10, @keywords, @key, 1)

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
