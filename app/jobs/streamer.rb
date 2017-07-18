#Resque can maintain multiple queues for different job types. By setting the @queue class instance variable,
#this worker will only look for jobs on the :sleep queue.

require 'json'

class Streamer
  @queue = :stream

  def self.perform(n, keywords, key, caller)

    #If the key does not exist already, set the key topics
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
