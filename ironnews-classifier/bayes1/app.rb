
require "json"
require "bayes1/models"
require "bayes1/tokenizer"

get "/bayes1" do
  "bayes1"
end

get "/bayes1/documents" do
  @documents = BayesOneDocument.all
  erb(:"bayes1/documents")
end

get "/bayes1/categories" do
  @categories = BayesOneCategory.all
  erb(:"bayes1/categories")
end

get "/bayes1/features" do
  @features = BayesOneFeature.all(
    :order => [:quantity.desc],
    :limit => 50)
  erb(:"bayes1/features")
end

# FIXME: POST
get "/bayes1/add" do
  category = params[:category].to_s.strip
  body     = params[:body].to_s.strip

  if !category.empty? && !body.empty?
    unless BayesOneDocument.first(:body => body)
      document = BayesOneDocument.new(
        :category => category,
        :body     => body)
      document.save!
    end
  end
end

# FIXME: POST
get "/bayes1/remove" do
  documents = BayesOneDocument.all
  documents.each { |document| document.destroy }
  categories = BayesOneCategory.all
  categories.each { |category| category.destroy }
  features = BayesOneFeature.all
  features.each { |feature| feature.destroy }
  "remove"
end

get "/bayes1/train" do
  tokenizer = BayesOneTokenizer.new

  all_documents = BayesOneDocument.all(
    :trained => false,
    :limit   => 50)

  target_documents = all_documents.
    sort_by { rand }.
    slice(0, 2)

  target_documents.each { |document|
    # カテゴリの文書数をインクリメント
    category = BayesOneCategory.find_or_create(:name => document.category)
    category.quantity += 1
    category.save

    # 特徴の特徴数をインクリメント
    tokens = tokenizer.tokenize(document.body)
    tokens.each { |token|
      feature = BayesOneFeature.find_or_create(
        :category => document.category,
        :feature  => token)
      feature.quantity += 1
      feature.save
    }

    # 学習済みに変更
    document.trained = true
    document.save
  }

  #content_type(:json)
  content_type(:text)
  {"success" => true}.to_json
end

get "/bayes1/classify" do
  erb(:test)
end
