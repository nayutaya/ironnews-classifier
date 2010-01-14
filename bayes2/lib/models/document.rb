
class Document
  include DataMapper::Resource

  property :id,       Serial
  property :body,     Text,   :required => true
  property :category, String, :required => true, :length => 5

  has n, :features
end
