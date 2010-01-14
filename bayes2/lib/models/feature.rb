
class Feature
  include DataMapper::Resource

  property :id,      Serial
  property :feature, String, :required => true, :length => 20, :index => true

  belongs_to :document
end
