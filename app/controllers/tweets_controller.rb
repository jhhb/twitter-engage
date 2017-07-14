class TweetsController < ApplicationController

  def save
    @tweet = Tweet.new(tweet_params)

    if @tweet.save
      render js: 'tweet_saved'
    else
      render js: 'tweet_error'
    end
  end

  private

    def tweet_params
      puts params
      params.require(:tweet).permit(:text, :user_name, :user_handle, :topic)
    end

end
