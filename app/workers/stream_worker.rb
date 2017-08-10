class StreamWorker
  include Sidekiq::Worker

  def perform(n, keywords, key, caller)
    puts "Running sidekiq worker"

    unless $redis.exists(key)
      $redis.set(key + "-topics", keywords.to_json)
    end

    #If we are polling tweets
    if caller == 1
      keywords = JSON.parse(keywords)
    end
    TwitterService.get_and_set_tweets(keywords, key)
    puts $redis.llen(key)
   # $redis.set(key, TwitterService.get_n_tweets(n, keywords).to_json)
  end
end