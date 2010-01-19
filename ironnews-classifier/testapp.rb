#! ruby -Ku

require "sinatra"
require "dm-core"

require "models"

DataMapper.setup(:default, "appengine://auto")

=begin
helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end
=end

get "/" do
  doc = Document.create(:body => "body")
  cat = Category.create(:name => "name", :quantity => 1)
  fet = Feature.create(:category => "cat", :feature => "fet", :quantity => 2)

  "hello sinatra"
end
