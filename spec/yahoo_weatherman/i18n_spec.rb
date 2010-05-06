require 'spec_helper'

describe Weatherman::I18N do
  before do
    @response = Weatherman::Client.new(:lang => 'pt-br').lookup_by_woeid 455821
  end

  it 'should translate the conditions details' do
    @response.condition['text'].should == 'Predominantemente Nublado'
  end

  it 'should translate the location details' do
    @response.location['country'].should == 'Brasil'
    @response.location['city'].should == 'Santa Luzia'
    @response.location['region'].should == 'Minas Gerais'
  end

  it 'should translate the forecasts details' do
    @response.forecasts.first['text'].should == 'Chuva'
    @response.forecasts.last['text'].should == 'Tempestades Intermitentes'
    @response.forecasts.first['day'].should == 'Sábado'
    @response.forecasts.last['day'].should == 'Domingo'
  end
end


