
require "appengine-rack"

AppEngine::Rack.configure_app(
  :application => "ironnews-classifier1",
  :version     => "v1")

require "testapp"

run Sinatra::Application
