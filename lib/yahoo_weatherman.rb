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

  VERSION = '2.0.3'

  URI = 'https://query.yahooapis.com/v1/public/yql?q='

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
      raw = get woeid_query_url(woeid)
      Response.new(raw, options[:lang])
    end

    #
    # Looks up weather by location.
    #
    def lookup_by_location(location)
      raw = get location_query_url(location)
      Response.new(raw, options[:lang])
    end

    private

      def woeid_query_url(woeid)
        "#{URI}select%20*%20from%20weather.forecast%20where%20woeid%20%3D%20#{woeid}%20and%20u%20%3D%20'#{degrees_units}'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      end

      def location_query_url(location)
        "#{URI}select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{::CGI.escape(location)}%22)%20and%20u%20%3D%20'#{degrees_units}'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      end

      def degrees_units
        (options[:unit] || 'c').downcase
      end

      def get(url)
        open(url).read
      end
  end
end
