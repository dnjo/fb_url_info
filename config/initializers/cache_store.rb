CacheStore.configure do |config|
  config.store = Redis.new url: ENV['REDIS_URL']
  config.expire_time = ENV.fetch 'REDIS_EXPIRE_TIME', 15.minutes
end
