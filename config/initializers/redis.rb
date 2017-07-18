class DataCache
  def self.data
    @data ||= Redis.new(host: 'localhost', port: 6379)
  end

  def self.set(key, value)
    self.data.set(key, value)
  end

  def self.get(key)
    self.data.get(key)
  end

  def self.get_i(key)
    self.data.get(key).to_i
  end

  def self.exists(key)
    self.data.exists(key)
  end

  def self.get_topics(key)
    self.data.get(key + '-topics')
  end

  def self.set_topics(key, value)
   self.data.set(key + '-topics', value)
  end

  def self.delete_key(key)
    self.data.del(key)
  end
end