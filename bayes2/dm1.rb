#! ruby -Ku

require "rubygems"
require "dm-core"
require "facets"

DataMapper.setup(:default, "sqlite3:#{File.expand_path(__DIR__)}/brain.out")

class Document
  include DataMapper::Resource

  property :id,   Serial
  property :body, Text, :required => true, :lazy => false

  has n, :features
end

class Feature
  include DataMapper::Resource

  property :id,      Serial
  property :feature, Text, :required => true, :lazy => false

  belongs_to :document
end

DataMapper.auto_migrate!

f1 = Feature.new(:feature => "f1")

d1 = Document.new(:body => "d1")
d1.features << f1
d1.save
