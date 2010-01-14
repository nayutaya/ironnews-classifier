
class Feature
  include DataMapper::Resource

  property :id,      Serial
  property :feature, String, :required => true, :length => 20

  belongs_to :document
end
