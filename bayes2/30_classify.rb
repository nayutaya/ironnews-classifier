#! ruby -Ku -Ilib

require "config"

# あるカテゴリの中に、ある特徴が現れた数
def fcount(feature, category)
  #return ((@features[feature] || {})[category] || 0)
  return Feature.count("feature" => feature, "document.category" => category)
end

p fcount("jr", "鉄道")
