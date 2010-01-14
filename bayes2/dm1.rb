#! ruby -Ku -Ilib

require "rubygems"
require "dm-core"
require "facets"

require "models/document"
require "models/feature"

DataMapper.setup(:default, "sqlite3:#{__DIR__}/brain.out")
DataMapper.auto_migrate!

f1 = Feature.new(:feature => "f1")

d1 = Document.new(:body => "d1", :category => "c1")
d1.features << f1
d1.save
