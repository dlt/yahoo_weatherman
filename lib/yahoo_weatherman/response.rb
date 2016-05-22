# coding: utf-8

require 'json'

module Weatherman

  # = Response
  #
  # This is where we get access to the contents parsed by Nokogiri in a object-oriented way.
  # We also use this class to do the i18n stuff.
  #
  class Response

    attr_accessor :document_root

    def initialize(raw, language = nil)
      @document_root = JSON.parse(raw).dig('query', 'results', 'channel')
      @i18n = Weatherman::I18N.new(language)
    end

    #
    # Returns a hash containing the actual weather condition details:
    #
    #  condition = response.condition
    #  condition['text'] => "Tornado"
    #  condition['code'] => 0
    #  condition['temp'] => 21
    #  condition['date'] => #<Date: -1/2,0,2299161>
    #
    def condition
      condition = item_attribute('condition')
      translate! do_convertions(condition, [:code, :to_i], [:temp, :to_i], [:date, :to_date], :text)
    end

    #
    # Wind's details:
    #
    #  wind = response.wind
    #  wind['chill'] => 21
    #  wind['direction'] => 340
    #  wind['chill'] => 9.66
    #
    def wind
      do_convertions(attribute('wind'), [:chill, :to_i], [:direction, :to_i], [:speed, :to_f])
    end

    #
    # Forecasts for the next 2 days.
    #
    #  forecast = response.forecasts.first
    #  forecast['low'] => 20
    #  forecast['high'] => 31
    #  forecast['text'] => "Tornado"
    #  forecast['code'] => 0
    #  forecast['day'] => "Sat"
    #
    def forecasts
      convertions = [[:date, :to_date], [:low, :to_i], [:high, :to_i], [:code, :to_i], :day, :text]
      item_attribute('forecast').collect do |forecast|
        translate! do_convertions(forecast, *convertions)
      end
    end

    #
    # Location:
    #
    #  location = response.location
    #  location['country'] => "Brazil"
    #  location['region'] => "MG"
    #  location['city'] => Belo Horizonte
    #
    def location
      translate! attribute('location')
    end

    # Units:
    #
    #  units = response.units
    #  units['temperature']  => "C"
    #  units['distance']  => "km"
    #  units['pressure']  => "mb"
    #  units['speed']  => "km/h"
    #
    def units
      attribute('units')
    end

    #
    # Astronomy:
    #
    #  astronomy = response.astronomy
    #  astronomy['sunrise'] => "6:01 am"
    #  astronomy['sunset'] => "7:20 pm"
    #
    def astronomy
      attribute('astronomy')
    end

    #
    # Atmosphere :
    #
    #  atmosphere  = response.atmosphere
    #  atmosphere['humidity'] => "62"
    #  atmosphere['visibility'] => "9.99"
    #  atmosphere['pressure'] => "982.05"
    #  atmosphere['rising'] => "0"
    #
    def atmosphere
      atm = attribute('atmosphere')
      do_convertions(atm, [:humidity, :to_f], [:visibility, :to_f], [:pressure, :to_f], [:rising, :to_f])
    end

    #
    # Latitude:
    #
    #  response.latitude => -49.90
    def latitude
      geo_attribute('lat')
    end

    #
    # Longitude;
    #
    #  response.longitude => -45.32
    #
    def longitude
      geo_attribute('long')
    end

    #
    # A hash like object providing image info:
    #
    #  image = reponse.image
    #  image['width'] => 142
    #  image['height'] => 18
    #  image['title'] => "Yahoo! Weather"
    #  image['link'] => "http://weather.yahoo.com"
    #
    def image
      image = Weatherman::Image.new(attribute('image'))
      do_convertions(image, [:width, :to_i], [:height, :to_i], :title, :link, :url)
    end

    #
    # Description image. You might gonna need this if you have to customize the
    # forecast summary.
    #
    def description_image
      parsed_description.css('img').first # there's only one
    end

    #
    # A short HTML snippet (raw text) with a simple weather description.
    #
    def description
      doc = Nokogiri::XML.fragment(item_attribute('description'))
      doc.content
    end
    alias :summary :description

    #
    # Description parsed by Nokogiri. This is better then #description
    # if you have to walk through its nodes.
    #
    def parsed_description
      @parsed_description ||= Nokogiri::HTML(description)
    end

    private
      def attribute(attr, root = @document_root)
        elements = root[attr]
        elements.size == 1 ? elements.first : elements
      end

      def item_attribute(attr)
        attribute(attr, @document_root['item'])
      end

      def geo_attribute(attr)
        item_attribute(attr).to_f
      end

      def do_convertions(attributes, *pairs)
        pairs.inject({}) do |hash, (attr, method)|
          key = attr.to_s
          hash[key] = convert(attributes[key], method)
          hash
        end
      end

      def convert(value, method)
        return value unless method
        method == :to_date ? DateTime.parse(value) : value.send(method)
      end

      def translate!(attributes)
        @i18n.translate! attributes
      end
  end
end
