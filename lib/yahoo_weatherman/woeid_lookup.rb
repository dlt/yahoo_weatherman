module Weatherman
  class WoeidLookup

    def initialize(app_id)
      @app_id = app_id
    end

    def get_woeid(location)
      raw = get query_string(location)
      woeid_query = Nokogiri::HTML(raw).at_xpath('.//woeid')
      woeid_query ? woeid_query.content : nil
    end
    
    private

      def query_string(location)
        "http://where.yahooapis.com/v1/places.q('#{location}')?appid=#{@app_id}"
      end

      def get(url)
        open(url).read
      end

  end
end
