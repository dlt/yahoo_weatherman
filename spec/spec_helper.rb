path = File.expand_path(File.join([File.dirname(__FILE__), "..", "lib"]))
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'rubygems'
require 'fakeweb'
require 'yahoo_weatherman'
require 'rspec'

def celsius_fixture
  filepath = File.expand_path(File.join([File.dirname(__FILE__), "files", "belo_horizonte_c.rss"]))
  File.read filepath
end

def fahrenheight_fixture
  filepath = File.expand_path(File.join([File.dirname(__FILE__),  "files", "belo_horizonte_f.rss"]))
  File.read filepath
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, "http://weather.yahooapis.com/forecastrss?w=455821&u=c", :body => celsius_fixture)
FakeWeb.register_uri(:get, "http://weather.yahooapis.com/forecastrss?w=455821&u=f", :body => fahrenheight_fixture)
FakeWeb.register_uri(:get, "http://weather.yahooapis.com/forecastrss?w=123456&u=f", :body => celsius_fixture)
FakeWeb.register_uri(:get, "http://weather.yahooapis.com/forecastrss?w=4729347&u=c", :body => celsius_fixture)

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
    File.open(File.dirname(__FILE__) + "/files/#{file}.xml").read
  end

  def self.register_this_woeid_lookup_result(result, app_id, location)
    FakeWeb.register_uri(:get, "http://where.yahooapis.com/v1/places.q('#{location}')?appid=#{app_id}", :body => result)
  end

  def self.register_this_woeid_lookup_to_fail(app_id, location)
    FakeWeb.register_uri(:get, "http://where.yahooapis.com/v1/places.q('#{location}')?appid=#{app_id}", :exception => Net::HTTPError)
  end
end
