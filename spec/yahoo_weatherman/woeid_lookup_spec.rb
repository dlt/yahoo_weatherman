require 'spec_helper'
Dir[File.dirname(__FILE__) + '/directory/*.rb'].each {|file| require file }

describe Weatherman::WoeidLookup do
  describe "test_api_id and 66061" do 
    before do
      @app_id = 'test_api_id'
      @location = '66061'
      @lookup = Weatherman::WoeidLookup.new(@app_id)

      xml_result = File.open(File.dirname(__FILE__) + '/../files/woeid_result_for_66061_and_test_api_id.xml').read
      FakeWeb.register_uri(:get, "http://where.yahooapis.com/v1/places.q('#{@location}')?appid=#{@app_id}", :body => xml_result)
    end

    it "should retrieve the woeid" do
      response = @lookup.get_woeid(@location)
      response.should == "12786745"
    end
  end
end
