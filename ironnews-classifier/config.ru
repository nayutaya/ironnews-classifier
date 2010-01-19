
require "appengine-rack"

AppEngine::Rack.configure_app(
  :precompilation_enabled => true,
  :application => "ironnews-classifier1",
  :version     => "v1")

require "testapp"

run Sinatra::Application
