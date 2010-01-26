#! ruby -Ku

# ironnews-classifier1を使って記事を分類する

require "cgi"
require "open-uri"
require "rubygems"
require "json"

require "config"

THRESHOLDS = {
  "鉄道" => 1.0,
  "非鉄" => 3.5,
}

def classify(body)
  url  = "http://ironnews-classifier1.appspot.com/bayes1/classify"
  url += "?body=" + CGI.escape(body)

  count = 0
  begin
    json = open(url) { |io| io.read }
  rescue OpenURI::HTTPError => e
    p(e)
    count += 1
    retry if count <= 5
  end

  return JSON.parse(json)
end

def categorize(body)
  probs = classify(body).
    map     { |category, prob| [category, prob] }.
    sort_by { |category, prob| prob }

  first_category,  first_prob  = probs[-1]
  second_category, second_prob = probs[-2]

  if first_prob > second_prob * (THRESHOLDS[first_category] || 1.0)
    return first_category
  else
    return nil
  end
end

articles = Article.all(:gae_bayes1 => nil, :order => [:article_id.asc])
articles.each { |article|
  p article
  article.gae_bayes1 = categorize(article.title) || "不明"
  article.save!
}
