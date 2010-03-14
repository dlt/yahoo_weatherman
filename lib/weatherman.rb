require 'open-uri'
require 'response'

module Weatherman
  
  VERSION = '0.1'

  URI = 'http://weather.yahooapis.com/forecastrss'

  I18N_YAML_DIR = File.expand_path(File.dirname(__FILE__) + '/../i18n/')

  class Client
    attr_reader :options

    def initialize(options = {})
      @options = options
    end
    
    def lookup_by_woeid(woeid)
      raw = get request_url(woeid)
      Response.new(raw, options[:lang])
    end

    private
      def request_url(woeid)
        URI + query_string(woeid)
      end

      def query_string(woeid)
        "?w=#{woeid}&u=#{degrees_units}"
      end

      def degrees_units
        options[:degrees_units] || 'c'
      end

      def get(url)
        open(url) { |stream| stream.read } 
      end
  end

end
