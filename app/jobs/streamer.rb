#Resque can maintain multiple queues for different job types. By setting the @queue class instance variable,
#this worker will only look for jobs on the :sleep queue.

require 'json'

class Streamer
  @queue = :stream

  def self.perform(n, keywords)
    puts "N IN RESCUE: #{n}"
    puts "KEYWORD IN RESQ: #{keywords}"


    DataCache.set('tweets', TwitterService.get_n_tweets(n, keywords).to_json)
  end
end

