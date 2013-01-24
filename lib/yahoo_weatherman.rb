# coding: utf-8
path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'yaml'
require 'open-uri'
require 'nokogiri'

require 'yahoo_weatherman/i18n'
require 'yahoo_weatherman/image'
require 'yahoo_weatherman/woeid_lookup'
require 'yahoo_weatherman/response'

module Weatherman
  
  VERSION = '2.0.0'

  URI = 'http://weather.yahooapis.com/forecastrss'

  # = Client
  #
  # The weatherman client. Where it all begins.
  #
  class Client
    attr_reader :options

    #
    # Accepts an optional hash containing the client options.
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
      @uri = options[:url] || URI
    end
    
    #
    # Looks up weather by woeid. 
    #
    def lookup_by_woeid(woeid)
      raw = get request_url(woeid)
      Response.new(raw, options[:lang])
    end

    #
    # Looks up weather by location.
    #
    def lookup_by_location(location)
      lookup = WoeidLookup.new
      woeid = lookup.get_woeid(location)
      lookup_by_woeid(woeid)
    end

    private
      def request_url(woeid)
        @uri + query_string(woeid)
      end

      def query_string(woeid)
        "?w=#{woeid}&u=#{degrees_units}"
      end

      def degrees_units
        (options[:unit] || 'c').downcase
      end

      def get(url)
        open(url).read
      end
  end
end
