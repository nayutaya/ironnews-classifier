#! ruby -Ku -Ilib

require "config"
require "bigram_tokenizer"

STDERR.puts("initialize...")
tokenizer = BigramTokenizer.new

STDERR.puts("training...")
transaction = DataMapper::Transaction.new(Document, Feature)
transaction.commit {
  [
    ["鉄道", "../../ironnews-data/news_title/rail_01.txt"],
#    ["鉄道", "../../ironnews-data/news_title/rail_*.txt"],
#    ["非鉄", "../../ironnews-data/news_title/rest_*.txt"],
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
}
