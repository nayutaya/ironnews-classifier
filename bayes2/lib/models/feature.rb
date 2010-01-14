
class Feature
  include DataMapper::Resource

  property :id,      Serial
  property :feature, Text, :required => true, :lazy => false

  belongs_to :document
end
