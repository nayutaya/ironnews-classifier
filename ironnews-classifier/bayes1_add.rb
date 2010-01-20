#! ruby -Ku

# テスト用にデータを登録するためのスクリプト

require "cgi"
require "open-uri"

url  = "http://localhost:8080/bayes1/add"
url += "?category=" + CGI.escape("非鉄")
url += "&body=" + CGI.escape("これは鉄道関連ではない文章です")

open(url) { |io|
  p(io.read)
}
