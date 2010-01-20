
require "bayes1/models"

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
end

get "/bayes1/train" do
end
