class ShareInfo
  class << self
    def call(urls)
      request_info urls
    end

    private

    def request_info(urls)
      info = {}
      urls.each_slice(50) do |url_group|
        ids = urls_string url_group
        response = request_ids ids
        parsed_info = parse_response response, url_group
        info.merge! parsed_info
      end
      info
    end

    def request_ids(ids)
      query = { ids: ids }
      response = HTTParty.get base_url,
                              query: query
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

    def urls_string(urls)
      urls.join ','
    end

    def base_url
      'http://graph.facebook.com'
    end
  end
end
