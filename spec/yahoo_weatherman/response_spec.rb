# coding: utf-8
require 'spec_helper'

describe Weatherman::Response do
  before do
    @response = Weatherman::Client.new.lookup_by_woeid 455821
  end

  it 'should provide a location' do
    @response.location['city'].should == 'Belo Horizonte'
    @response.location['region'].should == 'MG'
    @response.location['country'].should == 'Brazil'
  end

  it 'should provide a weather condition' do
    @response.condition['code'].should ==  28
    @response.condition['temp'].should == 28
    @response.condition['text'].should == 'Mostly Cloudy'
    @response.condition['date'].should == Date.parse('Sat, 13 Mar 2010 11:00 pm LST')
  end

  it 'should provide the units used' do
    @response.units['temperature'].should == 'C'
    @response.units['distance'].should == 'km'
    @response.units['pressure'].should == 'mb'
    @response.units['speed'].should == 'km/h'
  end

  it 'should provide information about the wind' do
    @response.wind['chill'].should == 28
    @response.wind['direction'].should == 340
    @response.wind['speed'].should == 9.66
  end

  it 'should provide astronomy information' do
    @response.astronomy['sunrise'].should == '5:57 am'
    @response.astronomy['sunset'].should == '6:13 pm'
  end
  
  it 'should provide atmosphere information' do
    @response.atmosphere['humidity'].should == 62
    @response.atmosphere['visibility'].should == 9.99
    @response.atmosphere['pressure'].should == 982.05
    @response.atmosphere['rising'].should be_zero  	
  end

  it 'should get the next 2 forecasts' do
    first = @response.forecasts.first
    first['day'].should == 'Sat'
    first['date'].should == Date.parse('13 Mar 2010')
    first['low'].should == 18
    first['high'].should == 27
    first['text'].should == 'Showers'
    first['code'].should == 11

    last = @response.forecasts.last
    last['day'].should == 'Sun'
    last['date'].should == Date.parse('14 Mar 2010')
    last['low'].should == 18
    last['high'].should == 27
    last['text'].should == 'Scattered Thunderstorms'
    last['code'].should == 38
  end

  it 'should provide latitude and longitude' do
    @response.latitude.should == -19.95
    @response.longitude.should == -43.93
  end

  it 'should provide a description' do
    description = <<-DESCRIPTION

<img src="http://l.yimg.com/a/i/us/we/52/28.gif"/><br />
<b>Current Conditions:</b><br />
Mostly Cloudy, 28 C<BR />
<BR /><b>Forecast:</b><BR />
Sat - Showers. High: 27 Low: 18<br />
Sun - Scattered Thunderstorms. High: 27 Low: 18<br />
<br />
<a href="http://us.rd.yahoo.com/dailynews/rss/weather/Belo_Horizonte__BR/*http://weather.yahoo.com/forecast/BRXX0033_c.html">Full Forecast at Yahoo! Weather</a><BR/><BR/>
(provided by <a href="http://www.weather.com" >The Weather Channel</a>)<br/>
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
    image['url'].should == 'http://l.yimg.com/a/i/us/nws/th/main_142b.gif'
  end

  it 'should provide the forecast description icon' do
    image = @response.description_image
    image['src'].should == 'http://l.yimg.com/a/i/us/we/52/28.gif'
  end

  context 'using fahrenheiht as temperature unit' do

    it 'should return the temperature as fahrenheight' do
      client = Weatherman::Client.new :unit => 'F'
      response = client.lookup_by_woeid 455821

      response.units['temperature'].should == 'F'
      response.forecasts.first['low'].should == 63
      response.forecasts.last['low'].should == 63
      response.forecasts.first['high'].should == 75
      response.forecasts.last['high'].should == 79
      response.condition['temp'].should == 66
    end
  end

end
