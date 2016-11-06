require 'rails_helper'

describe CacheStore do
  before :each do
    @redis = Redis.new
    @expire_time = 15.minutes
    CacheStore.configure do |config|
      config.store = @redis
      config.expire_time = @expire_time
    end
  end

  describe '.get' do
    it 'gets a value' do
      key = 'testkey'
      value = 'testvalue'
      expect(@redis)
        .to(receive(:get))
        .with(key)
        .and_return value
      return_value = CacheStore.get key
      expect(return_value).to eq value
    end
  end

  describe '.set' do
    it 'sets a key value pair with an expire time' do
      key = 'testkey'
      value = 'testvalue'
      expect(@redis)
        .to(receive(:set))
        .with key, value
      expect(@redis)
        .to(receive(:expire))
        .with key, @expire_time
      CacheStore.set key, value
    end
  end
end
