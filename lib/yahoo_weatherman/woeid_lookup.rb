require 'cgi'
require 'json'

module Weatherman
  class WoeidLookup

    def get_woeid(location)
      raw = get query_string(location)
      JSON.parse(raw).dig('query', 'results', 'place', 'woeid')
    rescue
      nil
    end

    private

      def query_string(location)
        "https://query.yahooapis.com/v1/public/yql?q=select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{::CGI.escape(location)}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      end

      def get(url)
        open(url).read
      end

  end
end
