require 'spec_helper'

describe Weatherman::Client do
  describe "#lookup_by_woeid" do
    before do
      @client = Weatherman::Client.new
    end

    it 'should lookup by woeid' do
      response = @client.lookup_by_woeid 455821
      response.should be_instance_of(Weatherman::Response)
    end
  end

  describe "#lookup_by_location" do
    describe "4729347 example" do
      it "should lookup by location" do
        app_id = 'test_id'
        location = '78923'

        xml_result = WoeidHelper.open_test_file 'woeid_result_that_returns_4729347'
        WoeidHelper.register_this_woeid_lookup_result xml_result, app_id, location

        @client = Weatherman::Client.new( { :app_id => app_id } )
        response = @client.lookup_by_location location

        response.should be_instance_of(Weatherman::Response)
      end
    end

    describe "12786745 example" do
      it "should lookup by location" do
        app_id = 'apple'
        location = 'orange'

        xml_result = WoeidHelper.open_test_file 'woeid_result_that_returns_12786745'
        WoeidHelper.register_this_woeid_lookup_result xml_result, app_id, location

        @client = Weatherman::Client.new( { :app_id => app_id } )
        response = @client.lookup_by_location location

        response.should be_instance_of(Weatherman::Response)
      end
    end
  end

end
