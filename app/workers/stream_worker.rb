class StreamWorker
  include Sidekiq::Worker
  def perform(keywords, key)
    puts "Running sidekiq worker with #{keywords} and #{key}"
    TwitterService.get_and_set_tweets(keywords, key)
  end
end