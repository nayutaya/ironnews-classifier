#! ruby -Ku

require "open-uri"
require "rubygems"
require "nokogiri"

def get_area(url)
  entry = url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  html  = open(entry, {"Cache-Control" => "max-age=0"}) { |io| io.read }

  doc  = Nokogiri.HTML(html)
  div  = doc.css("#entryinfo-body").first
  link = div.css("a.location-link").first
  return link.text
end

data = <<EOS
http://mainichi.jp/area/aichi/news/20091116ddlk23040128000c.html	鉄道トラブル：新幹線線路侵入、容疑の男を逮捕－－豊橋署　／愛知 - 毎日ｊｐ(毎日新聞)
http://mainichi.jp/area/akita/news/20091116ddlk05040035000c.html	強風：被害、４人けが　空と鉄道、交通網乱れる　５７４１戸停電　／秋田 - 毎日ｊｐ(毎日新聞)
http://mainichi.jp/area/aomori/news/20091103ddlk02040059000c.html	鉄道事故：大湊線踏切で２人死亡　トラックと列車が衝突　／青森 - 毎日ｊｐ(毎日新聞)
http://mainichi.jp/area/chiba/news/20091029ddlk12040105000c.html	成田新高速鉄道：建設工事が大詰め　アクセス改善期待、空港－日暮里３６分　／千葉 - 毎日ｊｐ(毎日新聞)
EOS

data.lines.map { |line|
  line.strip.split(/\t/)
}.each { |url, title|
  p [url, title]
  p get_area(url)
  sleep 1.0
}


=begin
article_url = "http://www.yomiuri.co.jp/national/news/20100118-OYT1T00579.htm"

#File.open("src.html", "wb") { |file| file.write(src) }
src = File.open("src.html", "rb") { |file| file.read }
=end
