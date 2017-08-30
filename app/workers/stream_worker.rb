class StreamWorker
  include Sidekiq::Worker
  def perform(keywords, key)
    puts "Running sidekiq worker"

    unless $redis.exists(key)
      $redis.set(key + "-topics", keywords.to_json)
    end

    TwitterService.get_and_set_tweets(keywords, key)
  end
end