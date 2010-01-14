
require "rubygems"
require "dm-core"
require "dm-aggregates"
require "facets"

require "models/document"
require "models/feature"

#DataMapper::Logger.new(STDOUT, :debug)

case :postgres
when :sqlite3
  DataMapper.setup(:default, "sqlite3:#{__DIR__}/brain.out")
when :postgres
  DataMapper.setup(
    :default,
    :adapter  => "postgres",
    :database => "bayes2",
    :username => "postgres",
    :password => nil)
else raise
end
