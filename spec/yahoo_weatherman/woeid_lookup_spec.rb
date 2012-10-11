require 'spec_helper'
Dir[File.dirname(__FILE__) + '/directory/*.rb'].each {|file| require file }

describe Weatherman::WoeidLookup do
  describe "example with test_api_id and 66061" do 
    before do
      @app_id = 'test_api_id'
      @location = '66061'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_12786745') 
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @app_id, @location)
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
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @app_id, @location)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "4729347"
    end
  end

  describe "invalid api key" do 
    before do
      @app_id = 'invalid_api'
      @location = '12345'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = WoeidHelper.open_test_file('woeid_result_for_invalid_app_id') 
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @app_id, @location)
    end

    it "should return nil" do
      response = @lookup.get_woeid(@location)
      response.should == nil
    end
  end

  describe "failed net request" do 
    before do
      @app_id = 'net_failure'
      @location = '78902'
      @lookup = Weatherman::WoeidLookup.new(@app_id)
      WoeidHelper.register_this_woeid_lookup_to_fail @app_id, @location
    end

    it "should return nil" do
      response = @lookup.get_woeid(@location)
      response.should == nil
    end
  end

  describe "request with spaces" do
    before do
      @app_id = 'test_api_id'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_12786745')
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @app_id, "San%20Francisco,%20CA")
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid("San Francisco, CA")
      response.should == "12786745"
    end
  end
end
