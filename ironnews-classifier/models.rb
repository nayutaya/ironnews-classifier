
# 文書モデル
class Document
  include DataMapper::Resource

  property :id,      Serial
  property :body,    Text
  property :trained, Boolean, :default  => false
end

# カテゴリモデル
class Category
  include DataMapper::Resource

  property :id,       Serial
  property :name,     Text
  property :quantity, Integer
end

# 特徴モデル
class Feature
  include DataMapper::Resource

  property :id,       Serial
  property :category, Text
  property :feature,  Text
  property :quantity, Integer
end
