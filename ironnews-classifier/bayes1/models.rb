
# 文書モデル
class BayesOneDocument
  include DataMapper::Resource

  property :id,       Serial
  property :category, String
  property :body,     String
  property :trained,  Boolean, :default => false
end

# カテゴリモデル
class BayesOneCategory
  include DataMapper::Resource

  property :id,       Serial
  property :category, String
  property :quantity, Integer, :default => 0
end

# 特徴モデル
class BayesOneFeature
  include DataMapper::Resource

  property :id,       Serial
  property :category, String
  property :feature,  String
  property :quantity, Integer, :default => 0
end
