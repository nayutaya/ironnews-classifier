#! ruby -Ku

require "open-uri"
require "rubygems"
require "wsse"
require "json"

def read_credential
  File.open("config/ironnews.id") { |file|
    return [file.gets.chomp, file.gets.chomp]
  }
end

def create_token(username, password)
  return Wsse::UsernameToken.build(username, password).format
end

username, password = read_credential
token = create_token(username, password)

url  = "http://ironnews.nayutaya.jp/api/get_division_untagged_articles?per_page=100"
json = open(url, {"X-WSSE" => token}) { |io| io.read }
obj  = JSON.parse(json)

p obj["result"]["total_entries"]

articles = obj["result"]["articles"]

File.open("untagged_articles.out", "wb") { |file|
  articles.each { |article|
    article_id = article["article_id"]
    title      = article["title"].gsub(/[\r\n]/, "")
    file.puts([article_id, title].join("\t"))
  }
}
