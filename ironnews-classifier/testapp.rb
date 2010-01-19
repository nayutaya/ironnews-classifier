#! ruby -Ku

require "sinatra"
#require "dm-core"

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  "hello sinatra"
end
