class ShareInfoCache
  class << self
    def get(urls)
      cached_info = get_from_cache urls
      fetch_and_store cached_info
    end

    private

    def get_from_cache(urls)
      urls.each_with_object({}) do |url, cached_info|
        info = CacheStore.get url
        info = JSON.parse info, symbolize_names: true if info
        cached_info[url] = info
      end
    end

    def fetch_and_store(cached_info)
      uncached_urls = get_uncached_urls cached_info
      info = ShareInfo.call uncached_urls
      store_info info
      cached_info.merge info
    end

    def get_uncached_urls(cached_info)
      cached_info.each_with_object([]) do |(url, info), urls|
        urls << url unless info
      end
    end

    def store_info(url_info)
      url_info.each do |url, info|
        CacheStore.set url, info.to_json
      end
    end
  end
end
