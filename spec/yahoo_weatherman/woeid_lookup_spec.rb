require 'spec_helper'
Dir[File.dirname(__FILE__) + '/directory/*.rb'].each {|file| require file }

describe Weatherman::WoeidLookup do
  describe "example with test_api_id and 66061" do 

    before do
      @app_id = 'test_api_id'
      @location = '66061'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_12786745') 
      FakeWeb.register_uri(:get, "http://where.yahooapis.com/v1/places.q('#{@location}')?appid=#{@app_id}", :body => xml_result)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "12786745"
    end
  end

  describe "example with another_api and 90210" do 

    before do
      @app_id = 'another_api'
      @location = '90210'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_4729347') 
      FakeWeb.register_uri(:get, "http://where.yahooapis.com/v1/places.q('#{@location}')?appid=#{@app_id}", :body => xml_result)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "4729347"
    end
  end

end
