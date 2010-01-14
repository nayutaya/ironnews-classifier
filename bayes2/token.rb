#! ruby -Ku -Ilib

require "bigram_tokenizer"

tokenizer = BigramTokenizer.new

titles = File.foreach("../../ironnews-data/news_title/rail_01.txt").map { |line| line.strip }
titles.each { |title|
  puts(title)
  p(tokenizer.tokenize(title))
}
