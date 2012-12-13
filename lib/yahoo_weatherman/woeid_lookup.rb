require 'cgi'

module Weatherman
  class WoeidLookup

    def get_woeid(location)
      raw = get query_string(location)
      Nokogiri::HTML(raw).at_xpath('.//woeid').content
    rescue
      nil
    end

    private

      def query_string(location)
        "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20geo.placefinder%20where%20text%3D%22#{::CGI.escape(location)}%22%20and%20gflags%3D%22R%22"
      end

      def get(url)
        open(url).read
      end

  end
end
