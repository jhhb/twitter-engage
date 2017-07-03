# https://stackoverflow.com/questions/25595560/where-is-a-good-place-to-initialize-an-api

class TwitterService

  @@keywords = nil
  @@thread = nil
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
    puts "1"
    self.set_keywords(parsed_keywords)
    puts "2"
    self.run_with_keywords
    puts "3"
    return parsed_keywords
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
    @@keywords = parsed_keywords
  end

  def self.run_with_keywords
    topics = @@keywords
    @@thread = Thread.new {
      twitter_client.filter(track: topics.join(",")) do |object|
       puts object.text if object.is_a?(Twitter::Tweet)
      end
    }
  end

  def self.thread_is_running?
    return @@thread != nil
  end

  def self.stop_thread
    @@thread.exit
    @@thread = nil
  end



end