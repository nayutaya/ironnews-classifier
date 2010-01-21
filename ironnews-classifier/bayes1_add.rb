#! ruby -Ku

# テスト用にデータを登録するためのスクリプト

require "cgi"
require "uri"
require "net/http"
#require "open-uri"
require "rubygems"
require "json"

Net::HTTP.version_1_2

HOST = "localhost:8080"
#HOST = "ironnews-classifier1.appspot.com"

def add(category, body)
  p [category, body]
=begin
  url  = "http://#{HOST}/bayes1/add"
  url += "?category=" + CGI.escape(category)
  url += "&body=" + CGI.escape(body)
  open(url) { |io|
    p(io.read)
  }
=end
  obj = {"documents" => [["g","h"], ["i","j"]]}
  param = "json=#{CGI.escape(obj.to_json)}"
  url = "http://#{HOST}/bayes1/add"
  uri = URI.parse(url)
  Net::HTTP.start(uri.host, uri.port) { |http|
    res = http.post(uri.path, param)
    p res
    p res.body
  }
end

rails = File.foreach("rail_01.txt").map { |line| line.strip }.sort_by { rand }[0, 10]
rests = File.foreach("rest_01.txt").map { |line| line.strip }.sort_by { rand }[0, 10]

rails.slice!(0, 8)
rails.each { |title| add("鉄道", title) }
#rests.each { |title| add("非鉄", title) }
