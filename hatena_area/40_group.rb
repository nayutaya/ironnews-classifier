#! ruby -Ku

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

articles = File.foreach("area_untagged_articles_lookuped.out").
  map { |line| line.strip.split(/\t/) }.
  map { |article_id, pref, url, title| [article_id.to_i, pref, url, title] }

File.open("area_untagged_articles_grouped.out", "wb") { |file|
  articles.each { |article_id, pref, url, title|
    area = get_area(pref)
    file.puts([article_id, pref, area, url, title].join("\t"))
  }
}
