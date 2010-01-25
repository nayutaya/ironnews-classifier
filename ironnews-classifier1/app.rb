
require "sinatra"
require "dm-core"
require "dm-ar-finders"

DataMapper.setup(:default, "appengine://auto")

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "ironnews-classifier"
end
