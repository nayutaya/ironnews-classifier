#! ruby -Ku -Ilib

require "config"
require "bigram_tokenizer"

STDERR.puts("initialize...")
tokenizer = BigramTokenizer.new

STDERR.puts("cleaning...")
Document.all.destroy!
Feature.all.destroy!

STDERR.puts("training...")
[
#  ["鉄道", "rail_xx.txt"],
#  ["鉄道", "../../ironnews-data/news_title/rail_xx.txt"],
  ["鉄道", "../../ironnews-data/news_title/rail_*.txt"],
  ["非鉄", "../../ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern).each { |path|
    STDERR.puts("#{category} #{path}")
    File.foreach(path) { |line|
      title  = line.chomp
      tokens = tokenizer.tokenize(title)

      document = Document.new(:body => title, :category => category)
      document.features = tokens.map { |token| Feature.new(:feature => token) }
      document.save

      STDERR.write(".")
    }
    STDERR.puts
  }
}
