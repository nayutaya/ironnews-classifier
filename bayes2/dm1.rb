#! ruby -Ku

require "rubygems"
require "dm-core"
require "facets"

DataMapper.setup(:default, "sqlite3:#{File.expand_path(__DIR__)}/test.db")

class Document
  include DataMapper::Resource

  property :id,   Serial
  property :body, String
end

DataMapper.auto_migrate!

=begin
class Feature
  include DataMapper::Resource
end
=end
