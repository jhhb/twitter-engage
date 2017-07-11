class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  @@keywords = nil

  def index

  end

  def set_keywords

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])
    Resque.enqueue(Streamer,10, *@keywords)
    @@keywords = @keywords

    respond_to do |format|
      format.js
    end

  end

  def get_tweets

    @tweets = []

    if @@keywords
      tweets = JSON.load(DataCache.get('tweets'))
      Resque.enqueue( Streamer,10, *@@keywords)

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
      params.require(:dashboard).permit(:keywords)
    end

end
