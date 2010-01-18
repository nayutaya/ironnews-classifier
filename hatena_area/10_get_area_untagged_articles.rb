#! ruby -Ku

require "yaml"
require "open-uri"
require "rubygems"
require "wsse"
require "json"

def create_token
  username = "hatena_area"
  password = YAML.load_file("ironnews.id")[username]
  return Wsse::UsernameToken.build(username, password).format
end


token = create_token

url  = "http://ironnews.nayutaya.jp/api/get_area_untagged_articles?per_page=100"
json = open(url, {"X-WSSE" => token}) { |io| io.read }
obj  = JSON.parse(json)

p obj["result"]["total_entries"]

articles = obj["result"]["articles"]

File.open("area_untagged_articles.out", "wb") { |file|
  articles.each { |article|
    article_id = article["article_id"]
    title      = article["title"]
    file.puts([article_id, title].join("\t"))
  }
}
