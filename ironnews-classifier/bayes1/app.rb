
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
  @features = BayesOneFeature.all
  erb(:"bayes1/features")
end
