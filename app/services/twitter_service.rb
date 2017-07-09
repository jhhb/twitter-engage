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
    limit = n
    puts "keywords: #{keywords}"
    topics = keywords
    tweets = []

    joined_topics = topics.join(',')

    puts joined_topics
    puts joined_topics.class

    topics = joined_topics.split(",")
    puts "topics class: #{topics.class}   topics.class"

      twitter_client.filter(filter_level: 'low', track: joined_topics ) do |object|
        puts "In twitter_client filter"
        if limit == 0
          break
        end

        tweet_topic = ""

        topics.each do |topic|
          puts object.text.downcase
          puts "topic: #{topic}"
          if object.text.downcase.include?(topic)
            tweet_topic = topic
            break
          end
        end

        # myHash = {}
        #
        # object.text.split.each do |word|
        #   myHash[word] = 1
        # end
        #
        # puts "topics: #{topics}"
        # puts "object.text: #{object.text.split}"
        # puts "my hash : #{myHash}"
        #
        # tweet_topic = ""
        #
        # topics.each do |topic|
        #   if myHash[topic] == 1
        #     tweet_topic = topic
        #   end
        # end

        if tweet_topic == ""
          puts "no topic obj: #{object}"
        end

        tweets << [object, tweet_topic]

        limit -=1

        puts "tweet topic: #{tweet_topic}"
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