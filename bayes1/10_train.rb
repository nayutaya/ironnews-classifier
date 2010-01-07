#! ruby -Ku -Ilib

# 単純ベイズ分類器によるカテゴリ分類を学習する

require "naive_bayes_categorizer"

DB_FILENAME = "db.out"

STDERR.puts("initialize...")
tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.new(tokenizer)

STDERR.puts("training...")
[
  ["rail", "../../ironnews-data/news_title/rail_*.txt"],
  ["rest", "../../ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern).each { |path|
    STDERR.puts("#{category} #{path}")
    File.foreach(path) { |line|
      title = line.chomp
      categorizer.train(category, title)
    }
  }
}

STDERR.puts("saving...")
categorizer.save(DB_FILENAME)
