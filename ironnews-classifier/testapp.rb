#! ruby -Ku

require "pure_nkf"

get "/" do
  #obj = JSON.parse(params[:json])
  #doc = Document.create(:body => "body")
  #cat = Category.create(:name => "name", :quantity => 1)
  #fet = Feature.create(:category => "cat", :feature => "fet", :quantity => 2)
  #PureNKF.convert_Z1("ｈｅｌｌｏ　ｓｉｎａｔｒａ")
  #{"a" => 1}.to_json
  ""
end

get "/train" do
  category = "鉄道"
  document = "本日は晴天なり"
  tokens   = document.scan(/./u).enum_cons(2).map { |a| a.join("") }

#=begin
  tokens.each { |token|
    # FIXME: find_or_create相当のものはない？
    feature   = Feature.first(:category => category, :feature => token)
    feature ||= Feature.new(:category => category, :feature => token)
    feature.quantity += 1
    feature.save!
  }

  ""
#=end

=begin
  #Feature.all(:conditions => {:category => "x"}, :limit => 10).inspect
  query = AppEngine::Datastore::Query.new("Features")
  #query.filter(:category, "=", "x")
  records = query.fetch(:limit => 1000).to_a
  AppEngine::Datastore.delete(records.map { |x| x.key })
  return records.inspect
=end
end
