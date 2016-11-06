class ShareInfoCache
  class << self
    def get(urls)
      cached_info = get_from_cache urls
      fetch_and_store cached_info
    end

    private

    def get_from_cache(urls)
      urls.each_with_object({}) do |url, cached_info|
        cached_info[url] = cache_get url
      end
    end

    def fetch_and_store(cached_info)
      uncached_urls = get_uncached_urls cached_info
      info = ShareInfo.call uncached_urls
      store_info info
      cached_info.merge info
    end

    def get_uncached_urls(cached_info)
      cached_info.select { |_url, info| info.nil? }.keys
    end

    def store_info(url_info)
      url_info.each { |url, info| cache_set url, info }
    end

    def key_prefix
      'share_info-'
    end

    def cache_get(url)
      info = CacheStore.get "#{key_prefix}#{url}"
      JSON.parse info, symbolize_names: true if info
    end

    def cache_set(url, info)
      CacheStore.set "#{key_prefix}#{url}", info.to_json
    end
  end
end
