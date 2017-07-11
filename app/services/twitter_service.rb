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
    return parsed_keywords
  end

  def self.get_n_tweets(n, keywords)
    limit = n
    topics = keywords
    tweets = []

    joined_topics = topics.join(',')

    puts joined_topics
    puts joined_topics.class

    topics = joined_topics.split(",")

    puts "topics class: #{topics.class}   topics.class"

    sleep(2.seconds)

      twitter_client.filter(filter_level: 'low', track: joined_topics ) do |object|
        puts "In twitter_client filter"
        if limit == 0
          break
        end

        tweet_topic = nil

        topics.each do |topic|
          puts object.text.downcase
          puts "topic: #{topic}"
          if object.text.downcase.include?(topic)
            tweet_topic = topic
            break
          end
        end


        puts "Object start"

        #print_tweet(object)

        puts "Object end"

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