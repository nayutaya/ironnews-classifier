
require "facets"

class BayesOneClassifier
  def initialize
    # nop
  end

  # あるカテゴリの中に、ある特徴が現れた数
  def fcount(feature, category)
    @_fcount                    ||= {}
    @_fcount[category]          ||= {}
    @_fcount[category][feature] ||= BayesOneFeature.
      all(:category => category, :feature => feature).
      map(&:quantity).sum
    return @_fcount[category][feature]
  end

  # あるカテゴリの中のドキュメント数
  def catcount(category)
    @_catcount ||= {}
    @_catcount[category] ||= BayesOneCategory.
      all(:category => category).
      map(&:quantity).sum
    return @_catcount[category]
  end

  # ドキュメントの総数
  def totalcount
    @_totalcount ||= BayesOneCategory.all.map(&:quantity).sum
    return @_totalcount
  end

  # カテゴリの一覧
  def categories
    @_categories ||= BayesOneCategory.all.map(&:category).sort.uniq
    return @_categories
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
      sum.to_f
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
    return self.categories.mash { |category|
      [category, self.prob(features, category)]
    }
  end
end
