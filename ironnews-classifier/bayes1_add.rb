#! ruby -Ku

# テスト用にデータを登録するためのスクリプト

require "cgi"
require "uri"
require "net/http"
#require "open-uri"
require "rubygems"
require "json"
require "facets"

Net::HTTP.version_1_2

HOST = "localhost:8080"
#HOST = "ironnews-classifier1.appspot.com"

def add_documents(documents)
  uri   = URI.parse("http://#{HOST}/bayes1/add")
  param = {"documents" => documents}
  data  = "json=#{CGI.escape(param.to_json)}"

  Net::HTTP.start(uri.host, uri.port) { |http|
    res = http.post(uri.path, data)
    p([res.code, JSON.parse(res.body)])
  }
end

documents  = []
documents += File.foreach("rail_01.txt").map(&:strip).map { |title| ["鉄道", title] }.sort_by { rand }[0, 10]
documents += File.foreach("rest_01.txt").map(&:strip).map { |title| ["非鉄", title] }.sort_by { rand }[0, 10]

documents.each_slice(5) { |parts|
  add_documents(parts)
}
