#! ruby -Ku -Ilib

# 多層パーセプトロンネットワークによる学習を行う

require "mlp_categorizer"

DB_FILENAME = "db.out"
COUNT       = 5

STDERR.puts("initialize...")
tokenizer   = BigramTokenizer.new
categorizer = MlpCategorizer.new(tokenizer)

STDERR.puts("shuffling...")
training_data = []
[
  ["rail", "../../ironnews-data/news_title/rail_*.txt"],
  ["rest", "../../ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern).each { |path|
    STDERR.puts("#{category} #{path}")
    File.foreach(path) { |line|
      title = line.chomp
      training_data << [category, title]
    }
  }
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
