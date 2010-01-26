
require "rubygems"
require "dm-core"
require "dm-aggregates"
require "dm-ar-finders"
require "facets"

require "models"

DataMapper.setup(:default, "sqlite3:#{__DIR__}/db.out")
