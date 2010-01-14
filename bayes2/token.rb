#! ruby -Ku -Ilib

require "bigram_tokenizer"

tokenizer = BigramTokenizer.new

table = Hash.new(0)

titles = File.foreach("../../ironnews-data/news_title/rail_01.txt").map { |line| line.strip }
titles.each { |title|
  puts
  puts(title)
  tokens = tokenizer.tokenize(title)
  p(tokenizer.tokenize(title))
  tokens.each { |token|
    table[token] += 1
  }
}

puts
table.to_a.sort_by { |k, v| -v }.each { |token, count|
  p([token, count])
}
