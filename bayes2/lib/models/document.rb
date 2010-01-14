
class Document
  include DataMapper::Resource

  property :id,       Serial
  property :body,     Text,   :required => true, :lazy => false
  property :category, String, :required => true

  has n, :features
end
