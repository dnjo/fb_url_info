require 'rails_helper'

describe ShareInfoCache do
  describe '.get' do
    it 'gets info from cache' do
      url = 'testurl'
      info = { testinfo: 'testvalue' }
      expect(CacheStore)
        .to(receive(:get))
        .with("share_info-#{url}")
        .and_return info.to_json
      return_info = ShareInfoCache.get [url]
      expect(return_info[url]).to eq info
    end

    it 'fetches and stores in cache if not in cache' do
      url = 'testurl'
      info = { testinfo: 'testvalue' }
      expect(CacheStore)
        .to(receive(:get))
        .with("share_info-#{url}")
        .and_return nil
      expect(ShareInfo)
        .to(receive(:call))
        .with([url])
        .and_return url => info
      expect(CacheStore)
        .to(receive(:set))
        .with "share_info-#{url}", info.to_json
      return_info = ShareInfoCache.get [url]
      expect(return_info[url]).to eq info
    end
  end
end
