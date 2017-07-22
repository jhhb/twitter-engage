# https://stackoverflow.com/questions/25595560/where-is-a-good-place-to-initialize-an-api

require 'json'

class TwitterService

  @keywords = nil
  @thread = nil
  @tweets = nil

  @last_tweet_index = 0

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

  def self.get_n_tweets(n, keywords)
    limit = n
    puts keywords.inspect

    tweets = []

    joined_topics = keywords.join(',')

    topics = joined_topics.split(",")

    sleep(2.seconds)

      twitter_client.filter(filter_level: 'low', track: joined_topics ) do |object|
        if limit == 0
          break
        end

        tweet_topic = nil

        topics.each do |topic|
          if object.text.downcase.include?(topic)
            tweet_topic = topic
            break
          end
        end

        # This currently filters all retweets / replies
        if tweet_topic
          tweets << [object, tweet_topic]
          limit -=1
        end
      end

    return tweets

  end

  private

    def self.print_tweet(tweet_object)
      puts tweet.attrs.inspect
    end

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

    def self.set_keywords(parsed_keywords)
      @keywords = parsed_keywords
    end

end