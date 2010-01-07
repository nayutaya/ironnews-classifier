#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "wsse"

def read_credential
  File.open("config/ironnews.id") { |file|
    return [file.gets.chomp, file.gets.chomp]
  }
end

def create_token(username, password)
  return Wsse::UsernameToken.build(username, password).format
end

def tagging(article_id, tag)
  username, password = read_credential
  token = create_token(username, password)
  url  = "http://ironnews.nayutaya.jp/api/add_tags?article_id=#{article_id}&tag1=#{CGI.escape(tag)}"
  json = open(url, {"X-WSSE" => token}) { |io| io.read }
end

File.foreach("tagging.out") { |line|
  tag, article_id, title = line.chomp.split(/\t/)
  puts(article_id)
  tagging(article_id, tag)
}
