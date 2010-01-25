#! ruby -Ku

# Google App Engine上の単純ベイズ分類器に登録するための学習データを集める

documents = []

[
  ["鉄道", "../../../../ironnews-data/news_title/rail_*.txt"],
  ["非鉄", "../../../../ironnews-data/news_title/rest_*.txt"],
].each { |category, pattern|
  Dir.glob(pattern) { |filepath|
    STDERR.puts(filepath)
    File.foreach(filepath).
      map  { |line| line.strip }.
      each { |line| documents << [category, line] }
  }
}

srand(0)
File.open("documents.txt", "wb") { |file|
  documents.
    sort_by { rand }.
    each { |category, title| file.puts([category, title].join("\t")) }
}
