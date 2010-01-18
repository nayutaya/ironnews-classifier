#! ruby -Ku

require "open-uri"
require "rubygems"
require "nokogiri"

article_url = "http://www.yomiuri.co.jp/national/news/20100118-OYT1T00579.htm"
entry_url   = article_url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")

#src = open(entry_url, {"Cache-Control" => "max-age=0"}) { |io| io.read }
#File.open("src.html", "wb") { |file| file.write(src) }
src = File.open("src.html", "rb") { |file| file.read }

doc = Nokogiri.HTML(src)
table = doc.css("#entryinfo-body").first
#p table
links = table.css("a.location-link")
p links
puts links.first.text
