require 'rails_helper'

describe Api::V1::ShareInfoController, type: :controller do
  describe '#show' do
    it 'renders cached share info' do
      urls = 'testurl1,testurl2'
      info = { testurl: 'testinfo' }
      expect(ShareInfoCache)
        .to(receive(:get))
        .with(urls.split(','))
        .and_return info
      get :show, params: { urls: urls }
      expect(response.status).to eq 200
      expect(response.content_type). to eq 'application/json'
      expect(response.body).to eq info.to_json
    end

    it 'raises a ParameterMissing error if no URLs are passed' do
      expect { get :show }
        .to raise_error ActionController::ParameterMissing
      expect { get :show, params: { urls: nil } }
        .to raise_error ActionController::ParameterMissing
    end
  end
end
