#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "wsse"

def create_token
  username = "hatena_area"
  password = YAML.load_file("ironnews.id")[username]
  return Wsse::UsernameToken.build(username, password).format
end

def tagging(article_id, tag)
  token = create_token
  url  = "http://ironnews.nayutaya.jp/api/add_tags"
  url += "?article_id=#{article_id}"
  url += "&tag1=#{CGI.escape(tag)}"
  open(url, {"X-WSSE" => token}) { |io| io.read }
end

articles = File.foreach("area_untagged_articles_grouped.out").
  map { |line| line.strip.split(/\t/) }.
  map { |article_id, pref, area, url, title| [article_id.to_i, pref, area, url, title] }

articles.each { |article_id, pref, area, url, title|
  puts(article_id)
  tagging(article_id, pref)
  tagging(article_id, area)
  sleep(0.1)
}
