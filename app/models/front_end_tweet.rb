# Summary:
#   Class wraps the output of a tweet from Twitter with relevant info.
#   This is done so that I can more easily consume it in the front-end

#   TODOs: render JSON directly in front-end?
class FrontEndTweet
  attr_reader :text, :created_at, :user_id, :user_name, :user_handle, :user_location, :user_timestamp_ms, :user_profile_image_url, :tweet_id, :topic

  # Parameters: tweet_attrs from a Tweet object, topic that is caught in the Twitter stream.
  def initialize(tweet_attrs, topic)
    @text = tweet_attrs["text"]
    @created_at = tweet_attrs["created_at"]
    @user_id = tweet_attrs["user"]["id"]
    @user_name = tweet_attrs["user"]["name"]
    @user_handle = tweet_attrs["user"]["screen_name"]
    @user_location = tweet_attrs["user"]["location"]
    @user_timestamp_ms = tweet_attrs["timestamp_ms"]
    @user_profile_image_url = tweet_attrs["user"]["profile_image_url"]
    @tweet_id = tweet_attrs["id"]
    @topic = topic
  end
end