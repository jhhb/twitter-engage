#Resque can maintain multiple queues for different job types. By setting the @queue class instance variable,
#this worker will only look for jobs on the :sleep queue.

require 'json'

class Streamer
  @queue = :stream

  def self.perform(*args)

    n = args[0]
    keywords = args.slice(1, args.length - 1 )

    key = args.last

    unless DataCache.data.exists(key)
      DataCache.set(key + "-topics", keywords)
    end

    DataCache.set(key, TwitterService.get_n_tweets(n, keywords).to_json)
  end
end

