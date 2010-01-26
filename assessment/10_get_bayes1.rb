#! ruby -Ku

# ironnewsから単純ベイズ分類器の分類結果を取得する

require "yaml"
require "cgi"
require "open-uri"
require "rubygems"
require "wsse"
require "json"

require "config"

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

["鉄道", "非鉄"].each { |category|
  page = 1
  begin
    STDERR.puts("page: #{page}")
    result = get_user_tagged_articles(category, page)
    articles = result["result"]["articles"]
    articles.each { |article|
      record = Article.find_or_create(:article_id => article["article_id"])
      record.title = article["title"]
      record.local_bayes1 = category
      record.save!
    }
    page += 1
  end while page <= result["result"]["total_pages"]
}
