require 'spec_helper'
Dir[File.dirname(__FILE__) + '/directory/*.rb'].each {|file| require file }

describe Weatherman::WoeidLookup do
  describe "example with 66061" do 
    before do
      @location = '66061'
      @lookup = Weatherman::WoeidLookup.new

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_12786745') 
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @location)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "12786745"
    end
  end

  describe "example with another_api and 90210" do 
    before do
      @location = '90210'
      @lookup = Weatherman::WoeidLookup.new

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_4729347') 
      WoeidHelper.register_this_woeid_lookup_result(xml_result, @location)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "4729347"
    end
  end

  describe "failed net request" do 
    before do
      @location = '78902'
      @lookup = Weatherman::WoeidLookup.new
      WoeidHelper.register_this_woeid_lookup_to_fail @location
    end

    it "should return nil" do
      response = @lookup.get_woeid(@location)
      response.should == nil
    end
  end

  describe "request with spaces" do
    before do
      @lookup = Weatherman::WoeidLookup.new

      xml_result = WoeidHelper.open_test_file('woeid_result_that_returns_12786745')
      WoeidHelper.register_this_woeid_lookup_result(xml_result, "San+Francisco%2C+CA")
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid("San Francisco, CA")
      response.should == "12786745"
    end
  end
end
