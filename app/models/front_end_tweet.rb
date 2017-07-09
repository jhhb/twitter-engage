class FrontEndTweet

  attr_reader :text, :created_at, :user_id, :user_name, :user_handle, :user_location, :user_timestamp_ms, :user_profile_image_url, :tweet_id, :topic

  def initialize(tweet_attrs, topic)

    puts tweet_attrs.class

    @text = tweet_attrs[:text]
    @created_at = tweet_attrs[:created_at]
    @user_id = tweet_attrs["user"]["id"]
    @user_name = tweet_attrs["user"]["name"]
    @user_handle = tweet_attrs["user"]["screen_name"]
    @user_location = tweet_attrs["user"]["location"]
    @user_timestamp_ms = tweet_attrs[:timestamp_ms]
    @user_profile_image_url = tweet_attrs["user"]["profile_image_url"]
    @tweet_id = tweet_attrs[:id]
    @topic = topic
  end



  # def text
  #   @text
  # end
  #
  # def created_at
  #   @created_at
  # end
  #
  # def user_id
  #   @user_id
  # end
  #
  # def user_name
  #   @user_name
  # end
  #
  # def user_screen_name
  #   @user_screen_name
  # end
  #
  # def user_location
  #   @user_location
  # end
  #
  # def user_timestamp_ms
  #   @user_timestamp_ms
  # end
  #
  # def user_profile_image_url
  #   @user_profile_image_url
  # end
end