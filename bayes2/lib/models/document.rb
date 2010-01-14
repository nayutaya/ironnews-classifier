
class Document
  include DataMapper::Resource

  property :id,       Serial
  property :category, String, :required => true, :length => 10, :index => true

  has n, :features
end
