class TablesController < ApplicationController

  def index
    @tweets_per_page = 25
    @total_tweets = Tweet.all.count
    @tweets = Tweet.first(@tweets_per_page)
  end

  def save

  end

end
