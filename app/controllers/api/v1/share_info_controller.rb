module Api
  module V1
    class ShareInfoController < ApplicationController
      def show
        url_info = ShareInfoCache.get urls_param
        render json: url_info
      end

      private

      def urls_param
        urls = params.require :urls
        urls.split ','
      end
    end
  end
end
