
class Article
  include DataMapper::Resource

  property :id,           Serial
  property :article_id,   Integer
  property :title,        String, :length => 200
  property :local_bayes1, String, :length => 10
  property :gae_bayes1,   String, :length => 10
end
