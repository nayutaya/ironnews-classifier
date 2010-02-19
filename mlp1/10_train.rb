#! ruby -Ku -Ilib

# 多層パーセプトロンネットワークによる学習を行う

require "yaml"
require "rubygems"
require "ironnews_utility"
require "mlp_categorizer"

DB_FILENAME = "db.out"
COUNT       = 5

STDERR.puts("initialize...")
tokenizer   = BigramTokenizer.new
categorizer = MlpCategorizer.new(tokenizer)

STDERR.puts("shuffling...")
training_data = []
[
  ["rail", "../../../femto/ironnews/ironnews-data/news_title/rail_*.txt"],
  ["rest", "../../../femto/ironnews/ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern).each { |path|
    STDERR.puts("#{category} #{path}")
    File.foreach(path) { |line|
      title = line.chomp
      training_data << [category, title]
    }
  }
}

articles = Dir.glob("../../../femto/ironnews/ironnews-data/ironnews/*.yaml").sort.inject({}) { |memo, filepath|
  STDERR.puts(filepath)
  memo.merge(YAML.load_file(filepath))
}
articles.
  sort_by { |article_id, article| article_id }.
  map     { |article_id, article|
    url       = article["url"]
    title     = article["title"]
    user_tags = article["user_tags"] || {}
    yuya_tags = user_tags["yuya"] || []
    division  = (yuya_tags & ["鉄道", "非鉄"]).first
    [url, title, division]
  }.
  reject { |url, title, division| division.nil? }.
  map    { |url, title, division|
    ctitle = IronnewsUtility.cleanse_title(url, title) rescue title
    [url, title, ctitle, division]
  }.
  reject { |url, title, ctitle, division| ctitle == title }.
  each   { |url, title, ctitle, division|
    case division
    when "鉄道" then training_data << ["rail", ctitle]
    when "非鉄" then training_data << ["rest", ctitle]
    else raise
    end
  }

srand(0)
training_data = training_data.sort_by { rand }

STDERR.puts("training...")
COUNT.times { |i|
  STDERR.printf("%i/%i\n", i + 1, COUNT)
  training_data.each { |category, line|
    categorizer.train(category, line)
  }
}

STDERR.puts("saving...")
categorizer.save(DB_FILENAME)
