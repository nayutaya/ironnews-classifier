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

File.open("area_untagged_articles.out", "wb") { |file|
  page = 1
  begin
    STDERR.puts("page: #{page}")

    url  = "http://ironnews.nayutaya.jp/api/get_area_untagged_articles?per_page=100&page=#{page}"
    json = open(url, {"X-WSSE" => create_token}) { |io| io.read }
    obj  = JSON.parse(json)

    articles = obj["result"]["articles"]
    articles.each { |article|
      article_id = article["article_id"]
      url        = article["url"]
      title      = article["title"]
      file.puts([article_id, url, title].join("\t"))
    }

    page += 1
    break if page > 20
  end while page <= obj["result"]["total_pages"]
}
