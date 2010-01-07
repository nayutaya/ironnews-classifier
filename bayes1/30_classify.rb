#! ruby -Ku -Ilib

# 単純ベイズ分類器によるカテゴリ分類を行う

require "naive_bayes_categorizer"

DB_FILENAME = "db.out"

STDERR.puts("loading...")
tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.load(tokenizer, DB_FILENAME)

thresholds = {
  "rail" => 1.0,
  "rest" => 3.5,
}

out = File.open("tagging.out", "wb")

STDERR.puts("categorizing...")
File.foreach("untagged_articles.out") { |line|
  article_id, title = line.chomp.split(/\t/)
  category = categorizer.categorize(title, thresholds)
  category_ja =
    case category
    when "rail" then "鉄道"
    when "rest" then "非鉄"
    when nil    then "不明"
    else raise
    end
  next if category_ja == "不明"
  next if /\A[A-Za-z0-9_=\-\.\? ]+\z/ =~ title
  out.puts([category_ja, article_id, title].join("\t"))
}
