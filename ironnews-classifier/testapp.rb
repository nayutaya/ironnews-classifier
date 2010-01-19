#! ruby -Ku

require "sinatra"
require "dm-core"

require "json"
require "pure_nkf"
require "models"

DataMapper.setup(:default, "appengine://auto")

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  #obj = JSON.parse(params[:json])
  #doc = Document.create(:body => "body")
  #cat = Category.create(:name => "name", :quantity => 1)
  #fet = Feature.create(:category => "cat", :feature => "fet", :quantity => 2)
  #PureNKF.convert_Z1("ｈｅｌｌｏ　ｓｉｎａｔｒａ")
  #{"a" => 1}.to_json

  obj.inspect
end

get "/documents" do
  @documents = Document.all
  erb :documents
end
