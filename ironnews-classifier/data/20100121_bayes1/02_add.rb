#! ruby -Ku

# Google App Engine上の単純ベイズ分類器に学習データを登録する

require "cgi"
require "uri"
require "net/http"
require "rubygems"
require "facets"
require "json"

Net::HTTP.version_1_2

# 追加済みの学習データを取得
added = File.foreach("added.txt").
  map { |line| line.strip }.
  map { |line| line.split(/\t/) }.
  mash { |category, title| ["#{category}:#{title}", true] }

# 学習データを取得（追加済みデータは除く）
documents = File.foreach("documents.txt").
  map { |line| line.strip }.
  map { |line| line.split(/\t/) }.
  reject { |category, title| added["#{category}:#{title}"] }

#p documents.size
#p added

uri = URI.parse("http://ironnews-classifier1.appspot.com/bayes1/add")

parts = documents[0, 5]

param = {"documents" => parts}
data  = "json=#{CGI.escape(param.to_json)}"

Net::HTTP.start(uri.host, uri.port) { |http|
  response  = http.post(uri.path, data)
  processed = JSON.parse(response.body)
  File.open("added.txt", "a") { |file|
    processed.each { |id, category, title|
      file.puts([category, title].join("\t"))
    }
  }
  p([response.code, processed.size])
}
