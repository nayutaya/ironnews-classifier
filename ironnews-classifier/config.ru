
require "appengine-rack"

AppEngine::Rack.configure_app(
  :precompilation_enabled => true,
  :application => "ironnews-classifier1",
  :version     => "v1")

require "app"
require "bayes1/app"
require "bayes1/models"

run Sinatra::Application
