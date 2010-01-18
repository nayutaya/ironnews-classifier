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

articles = File.foreach("area_untagged_articles_filtered.out").map { |line|
  line.strip.split(/\t/)
}.map { |article_id, url, title|
  [article_id.to_i, url, title]
}

File.open("area_untagged_articles_lookuped.out", "wb") { |file|
  articles.each { |article_id, url, title|
    STDERR.puts(url)
    area = get_area(url)
    if area
      file.puts([article_id, area, url, title].join("\t"))
    end

    sleep(0.2)
  }
}
