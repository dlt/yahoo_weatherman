require 'spec_helper'

describe Weatherman::Client do
  before do
    @client = Weatherman::Client.new
  end

  it 'should lookup by woeid' do
    response = @client.lookup_by_woeid 455821
    response.should be_instance_of Weatherman::Response
  end

end
