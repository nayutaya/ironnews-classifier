
require "json"
require "bayes1/models"
require "bayes1/tokenizer"
require "bayes1/classifier"

get "/bayes1" do
  "bayes1"
end

get "/bayes1/documents" do
  @documents = BayesOneDocument.all(
    :order => [:id.desc],
    :limit => 50)
  erb(:"bayes1/documents")
end

get "/bayes1/categories" do
  @categories = BayesOneCategory.all(
    :order => [:category.asc])
  erb(:"bayes1/categories")
end

get "/bayes1/features" do
  @features = BayesOneFeature.all(
    :order => [:quantity.desc],
    :limit => 50)
  erb(:"bayes1/features")
end

post "/bayes1/add" do
  json      = params[:json] || "{}"
  request   = JSON.parse(json)
  documents = request["documents"] || []

  # MEMO: bodyの一意性が保証されないことに注意すること

  result = documents.
    reject { |category, body| category.blank? }.
    reject { |category, body| body.blank? }.
    reject { |category, body| BayesOneDocument.first(:body => body) }.
    map    { |category, body| BayesOneDocument.new(:category => category, :body => body) }.
    each   { |document| document.save! }.
    map    { |document| [document.id, document.category, document.body] }

  content_type(:json)
  result.to_json
end

# FIXME: POST
=begin
get "/bayes1/remove" do
  documents = BayesOneDocument.all(:limit => 200)
  documents.each { |document| document.destroy }
  categories = BayesOneCategory.all(:limit => 200)
  categories.each { |category| category.destroy }
  features = BayesOneFeature.all(:limit => 200)
  features.each { |feature| feature.destroy }
  "remove"
end
=end

get "/bayes1/train" do
  tokenizer = BayesOneTokenizer.new

  all_documents = BayesOneDocument.all(
    :trained => false,
    :limit   => 50)

  target_documents = all_documents.
    sort_by { rand }.
    slice(0, 4)

  target_documents.each { |document|
    # カテゴリの文書数をインクリメント
    category = BayesOneCategory.find_or_create(:category => document.category)
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
  body = params[:body].to_s

  tokenizer  = BayesOneTokenizer.new
  classifier = BayesOneClassifier.new

  tokens = tokenizer.tokenize(body)
  probs  = classifier.classify(tokens)

  #content_type(:json)
  content_type(:text)
  return probs.to_json
end
