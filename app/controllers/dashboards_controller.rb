class DashboardsController < ApplicationController

  require 'json'
  include ActionView::Helpers::OutputSafetyHelper

  def show_user_dashboard
    render 'show_user_dashboard'
  end

  # Summary:  We get keywords, parse and clean them up to remove whitespaces,
  #           Delete the Redis session key for a given client, and then we issue a request to
  #           Sidekiq to run a thread for the given keywords and key,
  def set_keywords

    @key = dashboard_params[:key]

    @keywords = TwitterService.handle_keywords(dashboard_params[:keywords])

    # We delete the session key because we are going to be overwriting it with new Tweets with new keywords
    $redis.del(@key)

    # Run a stream with given keywords and session key
    StreamWorker.perform_async(@keywords, @key)

    respond_to do |format|
      format.js
    end

  end

  # Summary:  This method marshals gets tweets out of redis, removes the tweets from the redis list,
  #           loads each into a JSON object that then gets moved into a FrontEndTweet object to more easily
  #           consume the data in the front end.
  def get_tweets
    @tweets = []
    @key = dashboard_params[:key]

    tweets = $redis.lrange(@key, 0, 10)

    $redis.ltrim(@key, 10, $redis.llen(@key) )

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