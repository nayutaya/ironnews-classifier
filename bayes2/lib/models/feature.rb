
class Feature
  include DataMapper::Resource

  property :id,      Serial
  property :feature, String, :required => true, :length => 5

  belongs_to :document
end
