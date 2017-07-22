class StreamWorker
  include Sidekiq::Worker

  sidekiq_options retry: false

  def perform(n, keywords, key, caller)
    puts "Running sidekiq worker"

    unless DataCache.exists(key)
      DataCache.set_topics(key, keywords.to_json)
    end

    #If we are polling tweets
    if caller == 1
      keywords = JSON.parse(keywords)
    end

    DataCache.set(key, TwitterService.get_n_tweets(n, keywords).to_json)
  end
end