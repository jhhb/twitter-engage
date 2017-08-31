# https://stackoverflow.com/questions/25595560/where-is-a-good-place-to-initialize-an-api

require 'json'

class TwitterService

  cattr_reader :twitter_client, instance_accessor: false do
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"] #Rails.application.secrets.TWITTER_CONSUMER_KEY
      config.consumer_secret     = ENV["TWITTER_CONSUMER_KEY_SECRET"] #TWITTER_CONSUMER_KEY_SECRET
      config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]    #Rails.application.secrets.TWITTER_ACCESS_TOKEN
      config.access_token_secret = ENV["TWITTER_ACCESS_TOKEN_SECRET"] #Rails.application.secrets.TWITTER_ACCESS_TOKEN_SECRET
    end
  end

  def self.handle_keywords(keywords)
    parsed_keywords = self.parse_keywords(keywords)
    return parsed_keywords
  end

  # Summary: tracks keywords and pushes them into a Redis list
  def self.get_and_set_tweets(keywords, key)
    joined_topics = keywords.join(',')
    topics = joined_topics.split(",")

    # Set filter_level: 'low' to get a lot of tweets. TODOs: experiment with medium filter_level
    twitter_client.filter(filter_level: 'low', track: joined_topics ) do |object|

      tweet_topic = nil

      topics.each do |topic|
        if object.text.downcase.include?(topic)
          tweet_topic = topic
          break
        end
      end

      # This currently filters all retweets / replies, because these Tweets can have the topic in them but
      # not saved into the text field
      if tweet_topic
        $redis.lpush(key, [object, tweet_topic].to_json)
      end
    end
  end

  private

    # Summary: takes keywords as comma separated values and makes them trackable
    def self.parse_keywords(keywords)
      #get into a list
      parsed_keywords = keywords.split(",")

      #only want ones that are not whitespaces
      no_spaces = parsed_keywords.reject {
        |each| each.strip.length == 0
      }

      #then the ones that remain, remove whitespace
      no_spaces.each_with_index do |keyword, index|
        no_spaces[index] = keyword.strip
      end
      return no_spaces
    end
end