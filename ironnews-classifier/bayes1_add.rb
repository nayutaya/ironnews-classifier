#! ruby -Ku

# テスト用にデータを登録するためのスクリプト

require "cgi"
require "open-uri"

HOST = "localhost:8080"
#HOST = "ironnews-classifier1.appspot.com"

def add(category, body)
  p [category, body]
  url  = "http://#{HOST}/bayes1/add"
  url += "?category=" + CGI.escape(category)
  url += "&body=" + CGI.escape(body)
  open(url) { |io|
    p(io.read)
  }
end

rails = File.foreach("rail_01.txt").map { |line| line.strip }.sort_by { rand }[0, 10]
rests = File.foreach("rest_01.txt").map { |line| line.strip }.sort_by { rand }[0, 10]

rails.each { |title| add("鉄道", title) }
rests.each { |title| add("非鉄", title) }
