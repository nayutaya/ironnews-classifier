#! ruby -Ku -Ilib

require "config"
require "bigram_tokenizer"

class NaiveBayesClassifier
  # あるカテゴリの中に、ある特徴が現れた数
  def fcount(feature, category)
    #return ((@features[feature] || {})[category] || 0)
    return Feature.count("feature" => feature, "document.category" => category)
  end

  # あるカテゴリの中のドキュメント数
  def catcount(category)
    #return (@quantities[category] || 0)
    return Document.count(:category => category)
  end

  # ドキュメントの総数
  def totalcount
    #return @quantities.values.inject { |ret, val| ret + val }
    return Document.count
  end

  # カテゴリの一覧
  def categories
    #return @quantities.keys
    return repository(:default).adapter.select("SELECT category FROM documents GROUP BY category")
  end

  # ある特徴が、あるカテゴリに現れる確率
  def fprob(feature, category)
    count = self.catcount(category)
    return 0.0 if count == 0
    return self.fcount(feature, category).to_f / count.to_f
  end

  def weightedprob(feature, category, weight = 1.0, ap = 0.5)
    basicprob = self.fprob(feature, category)
    totals    = self.categories.
      map { |cat| self.fcount(feature, cat) }.
      inject { |ret, val| ret + val }.to_f
    return ((weight * ap) + (totals * basicprob)) / (weight + totals)
  end

  def docprob(features, category)
    return features.inject(1.0) { |prob, feature|
      prob * self.weightedprob(feature, category)
    }
  end

  def prob(features, category)
    catprob = self.catcount(category).to_f / self.totalcount.to_f
    docprob = self.docprob(features, category)
    return docprob * catprob
  end

  def classify(features)
    return self.categories.inject({}) { |memo, category|
      memo[category] = self.prob(features, category)
      memo
    }
  end
end

class NaiveBayesCategorizer
  def initialize(tokenizer)
    @tokenizer  = tokenizer
    @classifier = NaiveBayesClassifier.new
  end

  def classify(document)
    features = @tokenizer.tokenize(document)
    return @classifier.classify(features)
  end

  def categorize(document, thresholds = {})
    probs = self.classify(document).
      map     { |category, prob| [category, prob] }.
      sort_by { |category, prob| prob }

    first_category,  first_prob  = probs[-1]
    second_category, second_prob = probs[-2]

    if first_prob > second_prob * (thresholds[first_category] || 1.0)
      return first_category
    else
      return nil
    end
  end
end

tokenizer   = BigramTokenizer.new
categorizer = NaiveBayesCategorizer.new(tokenizer)

=begin
p classifier.fcount("jr", "鉄道")
p classifier.fcount("jr", "非鉄")
p classifier.catcount("鉄道")
p classifier.catcount("非鉄")
p classifier.totalcount
p classifier.categories
p classifier.fprob("jr", "鉄道")
p classifier.fprob("jr", "非鉄")
=end

thresholds = {
  "鉄道" => 1.0,
  "非鉄" => 3.5,
}

p categorizer.categorize("JR北海道が国鉄時代の特急を満喫できるツアーを発売", thresholds)
