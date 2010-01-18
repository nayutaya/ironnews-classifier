#! ruby -Ku

require "cgi"
require "open-uri"
require "rubygems"
require "json"
require "facets"

def get_combined_tags(article_ids)
  url  = "http://ironnews.nayutaya.jp/api/get_combined_tags"
  url += "?article_ids=" + CGI.escape(article_ids.sort.join(","))

  json = open(url) { |io| io.read }
  obj  = JSON.parse(json)

  return obj["result"].mash { |id, tags| [id.to_i, tags] }
end

list = File.foreach("area_untagged_articles.out").map { |line|
  line.strip.split(/\t/)
}

combined_tags = {}

list.each_slice(10).each { |records|
  article_ids = records.map { |article_id, url, title| article_id }
  combined_tags.merge!(get_combined_tags(article_ids))
break
}
p combined_tags
