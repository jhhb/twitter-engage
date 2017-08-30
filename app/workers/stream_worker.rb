class StreamWorker
  include Sidekiq::Worker
  def perform(keywords, key)
    puts "Running sidekiq worker"

    unless $redis.exists(key)
      $redis.set(key + "-topics", keywords.to_json)
    end

    # allows job to be deleted from controller
    TwitterService.get_and_set_tweets(keywords, key)
  end
end
