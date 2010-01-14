#! ruby -Ku -Ilib

require "rubygems"
require "dm-core"
require "facets"

require "config"
require "bigram_tokenizer"
require "models/document"
require "models/feature"


STDERR.puts("initialize...")
DataMapper.setup(:default, "sqlite3:#{__DIR__}/#{DB_FILENAME}")
DataMapper.auto_migrate!
tokenizer = BigramTokenizer.new

STDERR.puts("training...")
[
  ["鉄道", "../../ironnews-data/news_title/rail_01.txt"],
#  ["鉄道", "../../ironnews-data/news_title/rail_*.txt"],
#  ["非鉄", "../../ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern).each { |path|
    STDERR.puts("#{category} #{path}")
    File.foreach(path) { |line|
      title = line.chomp

      document = Document.new(:body => title, :category => category)

      tokens = tokenizer.tokenize(title)
      tokens.each { |token|
        document.features << Feature.new(:feature => token)
      }

      document.save
      STDERR.write(".")
    }
    STDERR.puts
  }
}
