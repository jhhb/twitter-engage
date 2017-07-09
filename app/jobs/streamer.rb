#Resque can maintain multiple queues for different job types. By setting the @queue class instance variable,
#this worker will only look for jobs on the :sleep queue.

require 'json'

class Streamer
  @queue = :stream

  def self.perform(*args)

    n = args[0]
    keywords = args.slice(1, args.length)

    puts "keywords in streamer : #{keywords}"

    DataCache.set('tweets', TwitterService.get_n_tweets(n, keywords).to_json)
  end
end

