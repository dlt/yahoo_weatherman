path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'open-uri'
require 'nokogiri'
require 'yaml'

require 'weatherman/image'
require 'weatherman/response'

module Weatherman
  
  VERSION = '0.2'

  URI = 'http://weather.yahooapis.com/forecastrss'

  I18N_YAML_DIR = File.expand_path(File.dirname(__FILE__) + '/../i18n/')

  # = Client
  #
  # The weatherman client. Where it all begins.
  #
  class Client
    attr_reader :options

    def initialize(options = {})
      @options = options
    end
    
    #
    # Just pass in a +woeid+ and it will return a Weatherman::Response object:w
    #
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
