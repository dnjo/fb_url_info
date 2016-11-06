class ShareInfo
  class << self
    def call(urls)
      request_info urls, 50, {}
    end

    private

    def request_info(urls, count, info)
      urls.each_slice count do |url_group|
        response = request_urls url_group
        parsed_info = parse_response response, url_group
        info.merge! parsed_info
      end
      info
    end

    def request_urls(urls)
      ids = urls.join ','
      response = HTTParty.get base_url,
                              query: { ids: ids }
      JSON.parse response.body.to_s, symbolize_names: true
    end

    def parse_response(response, url_group)
      url_group.each_with_object({}) do |url, url_info|
        info = response[url.to_sym]
        url_info[url] = get_share_info info
      end
    end

    def get_share_info(info)
      default_share_info = {
        comment_count: 0,
        share_count: 0
      }
      return default_share_info unless info && info[:share]
      default_share_info.merge info[:share]
    end

    def base_url
      'http://graph.facebook.com'
    end
  end
end
