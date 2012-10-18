require 'cgi'

module Weatherman
  class WoeidLookup

    def initialize(app_id)
      @app_id = app_id
    end

    def get_woeid(location)
      raw = get query_string(location)
      Nokogiri::HTML(raw).at_xpath('.//woeid').content
    rescue
      nil
    end
    
    private

      def query_string(location)
        "http://where.yahooapis.com/v1/places.q('#{::CGI.escape(location)}')?appid=#{@app_id}"
      end

      def get(url)
        open(url).read
      end

  end
end
