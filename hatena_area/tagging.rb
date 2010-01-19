#! ruby -Ku

# はてなブックマークから都道府県名を取得し、地域タグを設定する
# (1) ironnewsから地域タグが設定されていない記事を取得する
# (2) 各記事の合成タグを取得する
# (3) 「鉄道」合成タグが含まれている記事を取得する
# (4) はてなブックマークのエントリページから都道府県名を取得する
# (5) 都道府県タグ、地域タグをironnewsに送信する

require "yaml"
require "thread"
require "open-uri"
require "cgi"
require "digest/sha1"
require "rubygems"
require "wsse"
require "json"
require "facets"
require "nokogiri"

CREDENTIALS = YAML.load_file("ironnews.id")
USERNAME    = "hatena_area"
PASSWORD    = CREDENTIALS[USERNAME]

def get_area_untagged_articles(page)
  url  = "http://ironnews.nayutaya.jp/api/get_area_untagged_articles"
  url += "?per_page=100"
  url += "&page=#{page}"
  token = Wsse::UsernameToken.build(USERNAME, PASSWORD).format
  json  = open(url, {"X-WSSE" => token}) { |io| io.read }
  return JSON.parse(json)
end

def get_combined_tags(article_ids)
  hash  = Digest::SHA1.hexdigest(article_ids.sort.uniq.join(","))
  cache = "#{__DIR__}/cache/tags_#{hash}"

  if File.exist?(cache)
    json = File.open(cache, "rb") { |file| file.read }
  else
    url  = "http://ironnews.nayutaya.jp/api/get_combined_tags"
    url += "?article_ids=" + CGI.escape(article_ids.sort.join(","))
    json = open(url) { |io| io.read }
    File.open(cache, "wb") { |file| file.write(json) }
  end

  obj  = JSON.parse(json)
  return obj["result"].mash { |id, tags| [id.to_i, tags] }
end

def get_page(url)
  hash  = Digest::SHA1.hexdigest(url)
  cache = "#{__DIR__}/cache/#{hash}"
  if File.exist?(cache)
    return File.open(cache, "rb") { |file| file.read }
  else
    count = 5
    begin
      page = open(url, {"Cache-Control" => "max-age=0"}) { |io| io.read }
    rescue Timeout::Error
      count -= 1
      if count > 0
        retry
      end
    end
    File.open(cache, "wb") { |file| file.write(page) }
    return page
  end
end

def get_pref(url)
  entry = url.sub(/^http:\/\//, "http://b.hatena.ne.jp/entry/")
  html  = get_page(entry)
  doc  = Nokogiri.HTML(html)
  div  = doc.css("#entryinfo-body").first
  link = div.css("a.location-link").first if div
  return link.text if link
end

def get_area(pref)
  return {
    "北海道"   => "北海道",
    "青森県"   => "東北",
    "岩手県"   => "東北",
    "宮城県"   => "東北",
    "秋田県"   => "東北",
    "山形県"   => "東北",
    "福島県"   => "東北",
    "茨城県"   => "関東",
    "栃木県"   => "関東",
    "群馬県"   => "関東",
    "埼玉県"   => "関東",
    "千葉県"   => "関東",
    "東京都"   => "関東",
    "神奈川県" => "関東",
    "新潟県"   => "中部",
    "富山県"   => "中部",
    "石川県"   => "中部",
    "福井県"   => "中部",
    "山梨県"   => "中部",
    "長野県"   => "中部",
    "岐阜県"   => "中部",
    "静岡県"   => "中部",
    "愛知県"   => "中部",
    "三重県"   => "近畿",
    "滋賀県"   => "近畿",
    "京都府"   => "近畿",
    "大阪府"   => "近畿",
    "兵庫県"   => "近畿",
    "奈良県"   => "近畿",
    "和歌山県" => "近畿",
    "鳥取県"   => "中国",
    "島根県"   => "中国",
    "岡山県"   => "中国",
    "広島県"   => "中国",
    "山口県"   => "中国",
    "徳島県"   => "四国",
    "香川県"   => "四国",
    "愛媛県"   => "四国",
    "高知県"   => "四国",
    "福岡県"   => "九州",
    "佐賀県"   => "九州",
    "長崎県"   => "九州",
    "熊本県"   => "九州",
    "大分県"   => "九州",
    "宮崎県"   => "九州",
    "鹿児島県" => "九州",
    "沖縄県"   => "沖縄",
  }[pref] || raise("unknown pref -- #{pref}")
end

def tagging(article_id, tag)
  url  = "http://ironnews.nayutaya.jp/api/add_tags"
  url += "?article_id=#{article_id}"
  url += "&tag1=#{CGI.escape(tag)}"
  token = Wsse::UsernameToken.build(USERNAME, PASSWORD).format
  open(url, {"X-WSSE" => token}) { |io| io.read }
end


Thread.abort_on_exception = true
log_q               = Queue.new
all_articles_q      = Queue.new
packet_articles_q   = Queue.new
tagged_articles_q   = Queue.new
lookuped_articles_q = Queue.new

# ログを出力するスレッド
Thread.start {
  while message = log_q.pop
    STDERR.printf("[%s] %s\n", Time.now.strftime("%Y-%m-%d %H:%M:%S"), message)
  end
}

# 地域タグが設定されていない記事の一覧を取得するスレッド
Thread.start {
  log_q.push("start get articles thread")

  page = 1
  begin
    log_q.push("get page #{page}")
    ret = get_area_untagged_articles(page)

    ret["result"]["articles"].each { |article|
      all_articles_q.push({
        :id    => article["article_id"],
        :url   => article["url"],
        :title => article["title"]
      })
    }
    page += 1
    break if page > 5
  end while page <= ret["result"]["total_pages"]

  log_q.push("exit get articles thread")
  all_articles_q.push(nil)
}

# 合成タグを一括して取得するために10件ずつにまとめるスレッド
Thread.start {
  log_q.push("start packet thread")

  packet = []
  while article = all_articles_q.pop
    packet << article
    if packet.size >= 10
      packet_articles_q.push(packet)
      packet = []
    end
  end
  if packet.size >= 1
    packet_articles_q.push(packet)
  end

  log_q.push("end packet thread")
  packet_articles_q.push(nil)
}

# 合成タグを取得するスレッド
Thread.start {
  log_q.push("start get tags thread")

  while articles = packet_articles_q.pop
    ids = articles.map { |article| article[:id] }
    log_q.push("get tags #{ids.join(',')}")
    tags = get_combined_tags(ids)
    articles.each { |article|
      tags2 = tags[article[:id]]
      if tags2.include?("鉄道")
        tagged_articles_q.push(article.merge(:tags => tags2))
      end
    }
  end

  log_q.push("exit get tags thread")
  2.times {
    tagged_articles_q.push(nil)
  }
}

# 都道府県、地域を取得するスレッド
2.times { |i|
  Thread.start {
    log_q.push("start lookup area thread")

    while article = tagged_articles_q.pop
      url = article[:url]
      log_q.push("get pref:#{i} #{url}")
      pref = get_pref(url)
      if pref
        area = get_area(pref)
        lookuped_articles_q.push(article.merge(:pref => pref, :area => area))
      end
    end

    log_q.push("end lookup area thread")
    lookuped_articles_q.push(nil)
  }
}

# タグを設定するスレッド
Thread.start {
  log_q.push("start tagging thread")

  while article = lookuped_articles_q.pop
    id   = article[:id]
    pref = article[:pref]
    area = article[:area]
    log_q.push("add tag #{id}")
    tagging(id, pref)
    tagging(id, area)
  end

  log_q.push("exit tagging thread")
}#.join

gets

log_q.push("exit")
log_q.push(nil)
sleep(1)
