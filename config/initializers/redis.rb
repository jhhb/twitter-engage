#config/initializers/redis.rb

REDIS_CONFIG = YAML.load( File.open( Rails.root.join("config/redis.yml") ) ).symbolize_keys
cnfg = REDIS_CONFIG[Rails.env.to_sym].symbolize_keys
$redis = Redis.new(cnfg)