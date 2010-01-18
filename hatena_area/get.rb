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
  return link.text if link
end

data = <<EOS
http://mainichi.jp/select/biz/ushioda/news/20091115ddm008070052000c.html	千波万波：鉄道ルネサンス＝潮田道夫 - 毎日ｊｐ(毎日新聞)
http://mainichi.jp/select/jiken/archive/news/2009/11/26/20091126dde041040018000c.html	鉄道事故：線路に飛び降り、母娘？２人死傷－－横浜・相鉄線 - 毎日ｊｐ(毎日新聞)
EOS

data.lines.map { |line|
  line.strip.split(/\t/)
}.each { |url, title|
  STDERR.puts([url, title].inspect)
  p get_area(url)
  sleep 1.0
}
