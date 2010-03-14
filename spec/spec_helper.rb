path = File.expand_path(File.dirname(__FILE__) + "/../lib/")
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require 'rubygems'
require 'fakeweb'
require 'weatherman'
require 'spec'

def fixture
  filepath = File.expand_path(File.dirname(__FILE__) + "/files/belo_horizonte.rss")
  File.read filepath
end

FakeWeb.allow_net_connect = false
FakeWeb.register_uri(:get, "http://weather.yahooapis.com/forecastrss?w=455821&u=c", :body => fixture)
