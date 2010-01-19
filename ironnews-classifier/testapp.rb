#! ruby -Ku

require "sinatra"
require "dm-core"

DataMapper.setup(:default, "appengine://auto")

class Shout
  include DataMapper::Resource

  property :id,      Serial
  property :message, Text
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  shout = Shout.create(:message => "hoge")
  "hello sinatra"
end
