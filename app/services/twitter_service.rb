# https://stackoverflow.com/questions/25595560/where-is-a-good-place-to-initialize-an-api

require 'json'


class TwitterService

  @keywords = nil
  @thread = nil
  @tweets = nil

  @last_tweet_index = 0

  cattr_reader :twitter_client, instance_accessor: false do
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = Rails.application.secrets.TWITTER_CONSUMER_KEY
      config.consumer_secret     = Rails.application.secrets.TWITTER_CONSUMER_KEY_SECRET
      config.access_token        = Rails.application.secrets.TWITTER_ACCESS_TOKEN
      config.access_token_secret = Rails.application.secrets.TWITTER_ACCESS_TOKEN_SECRET
    end
  end

  def self.handle_keywords(keywords)
    parsed_keywords = self.parse_keywords(keywords)
    #self.set_keywords(parsed_keywords)
    #self.run_with_keywords
    return parsed_keywords
  end

  def self.get_n_tweets(n, keywords)
    puts "Hello?"
    limit = n
    topics = keywords
    tweets = []

      twitter_client.filter(track: topics.join(",")) do |object|
        puts "In twitter_client filter"
        if limit == 0
          break
        end


        myHash = {}

        object.text.split.each do |word|
          myHash[word] = 1
        end

        tweet_topic = nil

        topics.each do |topic|
          if myHash[topic] == 1
            tweet_topic = topic
          end
        end

        tweets << [object, "monkey"]

        puts "limit: #{limit}"
        limit -=1

      end



    return tweets

  end

  private

  # Iterate the keywords, split them up comma-separated, reject all the whitespace ones, and then strip
  #trailing and leading whitespace from the ones that remain. Then return and save them to
  #the class variable
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

  def self.run_with_keywords
    topics = @keywords
    @tweets = []
    limit = 20

    hash = {}

    @thread = Thread.new {
      twitter_client.filter(track: topics.join(",")) do |object|

        # filter_level: 'none'

        myHash = {}

        object.text.split.each do |word|
          myHash[word] = 1
        end

        tweet_topic = nil

        topics.each do |topic|
          if myHash[topic] == 1
            tweet_topic = topic
          end
        end

        @tweets << [object, tweet_topic]
      end
    }
  end

  def self.thread_is_running?
    return @thread != nil
  end

  def self.stop_thread
    @thread.exit
    @thread = nil
  end

  #NOT THREAD SAFE
  def self.get_last_tweets
    puts "Tweets inspect in get_last_tweets: #{@tweets.inspect}"
    tweets =  @tweets[@last_tweet_index, @tweets.length]
    return tweets
  end

  def self.nullify_tweets
    @tweets = []
  end

end