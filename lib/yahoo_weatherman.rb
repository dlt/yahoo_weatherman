path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'open-uri'
require 'nokogiri'
require 'yaml'

require 'yahoo_weatherman/image'
require 'yahoo_weatherman/response'

module Weatherman
  
  VERSION = '0.9'

  URI = 'http://weather.yahooapis.com/forecastrss'

  I18N_YAML_DIR = File.expand_path(File.join([File.dirname(__FILE__), '..', 'i18n']))

  # = Client
  #
  # The weatherman client. Where it all begins.
  #
  class Client
    attr_reader :options

    #
    # Accepts a optional hash containing the client options.
    #
    # Options:
    #
    #  +unit+: the unit used for the temperature (defaults to Celsius).
    #  "f" => Fahrenheight
    #  "c" => Celsius
    #
    #  +lang+: the language used in the response
    #
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
        (options[:unit] || 'c').downcase
      end

      def get(url)
        open(url) { |stream| stream.read } 
      end
  end
end
