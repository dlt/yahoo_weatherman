# coding: utf-8
require 'spec_helper'

describe Weatherman::Response do
  before do
    @response = Weatherman::Client.new.lookup_by_woeid 455821
  end

  it 'should provide a location' do
    @response.location['city'].should == 'Belo Horizonte'
    @response.location['region'].should == ' MG'
    @response.location['country'].should == 'Brazil'
  end

  it 'should provide a weather condition' do
    @response.condition['code'].should ==  32
    @response.condition['temp'].should == 22
    @response.condition['text'].should == 'Sunny'
    @response.condition['date'].should == DateTime.parse('Sun, 22 May 2016 09:00 AM BRT')
  end

  it 'should provide the units used' do
    @response.units['temperature'].should == 'C'
    @response.units['distance'].should == 'km'
    @response.units['pressure'].should == 'mb'
    @response.units['speed'].should == 'km/h'
  end

  it 'should provide information about the wind' do
    @response.wind['chill'].should == 72
    @response.wind['direction'].should == 68
    @response.wind['speed'].should == 11.27
  end

  it 'should provide astronomy information' do
    @response.astronomy['sunrise'].should == '6:20 am'
    @response.astronomy['sunset'].should == '5:25 pm'
  end

  it 'should provide atmosphere information' do
    @response.atmosphere['humidity'].should == 83.0
    @response.atmosphere['visibility'].should == 25.91
    @response.atmosphere['pressure'].should == 31290.24
    @response.atmosphere['rising'].should be_zero
  end

  it 'should get the next 2 forecasts' do
    first = @response.forecasts.first
    first['day'].should == 'Sun'
    first['date'].should == Date.parse('22 May 2016')
    first['low'].should == 16
    first['high'].should == 26
    first['text'].should == 'Sunny'
    first['code'].should == 32

    last = @response.forecasts.last
    last['day'].should == 'Tue'
    last['date'].should == Date.parse('31 May 2016')
    last['low'].should == 13
    last['high'].should == 26
    last['text'].should == 'Sunny'
    last['code'].should == 32
  end

  it 'should provide latitude and longitude' do
    @response.latitude.should == -19.899309
    @response.longitude.should == -43.964352
  end

  it 'should provide a description' do
    description = <<-DESCRIPTION
<img src=\"http://l.yimg.com/a/i/us/we/52/32.gif\"/>
<BR />
<b>Current Conditions:</b>
<BR />Sunny
<BR />
<BR />
<b>Forecast:</b>
<BR /> Sun - Sunny. High: 26Low: 16
<BR /> Mon - Scattered Thunderstorms. High: 26Low: 16
<BR /> Tue - Mostly Cloudy. High: 21Low: 16
<BR /> Wed - Partly Cloudy. High: 21Low: 14
<BR /> Thu - Partly Cloudy. High: 24Low: 13
<BR />
<BR />
<a href=\"http://us.rd.yahoo.com/dailynews/rss/weather/Country__Country/*https://weather.yahoo.com/country/state/city-455821/\">Full Forecast at Yahoo! Weather</a>
<BR />
<BR />
(provided by <a href=\"http://www.weather.com\" >The Weather Channel</a>)
<BR />
DESCRIPTION

    @response.description.should == description
    @response.description.should == @response.summary
  end

  it 'should provide the weather image attributes' do
    image = @response.image
    image['width'].should == 142
    image['height'].should == 18
    image['title'].should == 'Yahoo! Weather'
    image['link'].should == 'http://weather.yahoo.com'
    image['url'].should == 'http://l.yimg.com/a/i/brand/purplelogo//uh/us/news-wea.gif'
  end

  it 'should provide the forecast description icon' do
    image = @response.description_image
    image['src'].should == 'http://l.yimg.com/a/i/us/we/52/32.gif'
  end

  context 'using fahrenheiht as temperature unit' do

    it 'should return the temperature as fahrenheight' do
      client = Weatherman::Client.new :unit => 'F'
      response = client.lookup_by_woeid 455821

      response.units['temperature'].should == 'F'
      response.forecasts.first['low'].should == 61
      response.forecasts.last['low'].should == 57
      response.forecasts.first['high'].should == 80
      response.forecasts.last['high'].should == 79
      response.condition['temp'].should == 72
      response.condition['date'].should == DateTime.parse('Sun, 22 May 2016 09:00 AM BRT')
   end
  end

end
