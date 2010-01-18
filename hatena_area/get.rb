#! ruby -Ku

require "open-uri"
require "digest/sha1"
require "rubygems"
require "nokogiri"
require "facets"

def get_page(url)
  hash  = Digest::SHA1.hexdigest(url)
  cache = "#{__DIR__}/cache/#{hash}"
  if File.exist?(cache)
    return File.open(cache, "rb") { |file| file.read }
  else
    page = open(url, {"Cache-Control" => "max-age=0"}) { |io| io.read }
    File.open(cache, "wb") { |file| file.write(page) }
    return page
  end
end

def get_area(url)
  entry = url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  html  = get_page(entry)

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
