path = File.expand_path(File.join([File.dirname(__FILE__), "..", "lib"]))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'rubygems'
require 'fakeweb'
require 'yahoo_weatherman'
require 'rspec'

def celsius_fixture
  filepath = File.expand_path(File.join([File.dirname(__FILE__), "files", "belo_horizonte_c.json"]))
  File.read filepath
end

def fahrenheight_fixture
  filepath = File.expand_path(File.join([File.dirname(__FILE__),  "files", "belo_horizonte_f.json"]))
  File.read filepath
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%20455821%20and%20u%20%3D%20'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%20455821%20and%20u%20%3D%20'f'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => fahrenheight_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%20123456%20and%20u%20%3D%20'f'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%204729347%20and%20u%20%3D%20'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20%3D%2012786745%20and%20u%20%3D%20'c'&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22orange%22)%20and%20u%20%3D%20%27c%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)
FakeWeb.register_uri(:get, "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%2278923%22)%20and%20u%20%3D%20%27c%27&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys", :body => celsius_fixture)

module YAML
  class << self

    alias original_load load
    def load(ignored_arg)
      original_load(test_translation_file_stream)
    end

    def test_translation_file_stream
      File.read(File.join(File.dirname(__FILE__), 'files', 'test_i18n.yml'))
    end

  end
end

module WoeidHelper
  def self.open_test_file(file)
    File.open(File.dirname(__FILE__) + "/files/#{file}.json").read
  end

  def self.register_this_woeid_lookup_result(result, location)
    FakeWeb.register_uri(:get, lookup_uri(location), :body => result)
  end

  def self.register_this_woeid_lookup_to_fail(location)
    FakeWeb.register_uri(:get, lookup_uri(location), :exception => Net::HTTPError)
  end

  private

  def self.lookup_uri(location)
    "https://query.yahooapis.com/v1/public/yql?q=select%20woeid%20from%20geo.places(1)%20where%20text%3D%22#{location}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
  end
end
