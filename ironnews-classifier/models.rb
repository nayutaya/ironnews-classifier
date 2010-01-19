
# 文書モデル
class Document
  include DataMapper::Resource

  property :id,      Serial
  property :body,    String
  property :trained, Boolean, :default => false
end

# カテゴリモデル
class Category
  include DataMapper::Resource

  property :id,       Serial
  property :name,     String
  property :quantity, Integer, :default => 0
end

# 特徴モデル
class Feature
  include DataMapper::Resource

  property :id,       Serial
  property :category, String
  property :feature,  String
  property :quantity, Integer, :default => 0
end
