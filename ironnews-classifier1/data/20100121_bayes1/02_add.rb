#! ruby -Ku

# Google App Engine上の単純ベイズ分類器に学習データを追加する

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

uri = URI.parse("http://ironnews-classifier1.appspot.com/bayes1/add")

# 学習データを追加
documents.each_slice(20) { |parts|
  param = {"documents" => parts}
  data  = "json=#{CGI.escape(param.to_json)}"

  Net::HTTP.start(uri.host, uri.port) { |http|
    response = http.post(uri.path, data)

    if response.code == 200
      processed = JSON.parse(response.body)

      # 追加済みの学習データに追加
      File.open("added.txt", "a") { |file|
        processed.each { |id, category, title|
          file.puts([category, title].join("\t"))
        }
      }
    end

    STDERR.puts(Time.now.strftime("%H:%M:%S") + " " + response.code)
  }
}
