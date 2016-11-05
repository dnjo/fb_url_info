class CacheStore
  class << self
    attr_accessor :store,
                  :expire_time

    def configure
      yield self
    end

    def get(key)
      store.get key
    end

    def set(key, value)
      store.set key, value
      store.expire key, expire_time
    end
  end
end
