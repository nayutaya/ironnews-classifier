#! ruby -Ku

# ironnewsから単純ベイズ分類器の分類結果を取得する

require "yaml"
require "cgi"
require "open-uri"
require "rubygems"
require "wsse"
require "json"

CREDENTIALS = YAML.load_file("ironnews.id")
USERNAME    = "bayes1"
PASSWORD    = CREDENTIALS[USERNAME]

def get_user_tagged_articles(tag, page)
  url  = "http://ironnews.nayutaya.jp/api/get_user_tagged_articles"
  url += "?tag=#{CGI.escape(tag)}"
  url += "&page=#{page}"
  url += "&per_page=100"

  token = Wsse::UsernameToken.build(USERNAME, PASSWORD).format
  json  = open(url, {"X-WSSE" => token}) { |io| io.read }

  return JSON.parse(json)
end

p get_user_tagged_articles("鉄道", 2)
