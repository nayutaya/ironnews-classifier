
require "facets"

class BayesOneClassifier
  def initialize
    @logger = AppEngine::Logger.new
  end

  # あるカテゴリの中に、ある特徴が現れた数
  def fcount(feature, category)
    return BayesOneFeature.
      all(:category => category, :feature => feature).
      map(&:quantity).sum
  end

  # あるカテゴリの中のドキュメント数
  def catcount(category)
    return BayesOneCategory.
      all(:category => category).
      map(&:quantity).sum
  end

  # ドキュメントの総数
  def totalcount
    return BayesOneCategory.all.map(&:quantity).sum
  end

  # カテゴリの一覧
  def categories
    return BayesOneCategory.all.map(&:category).sort.uniq
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

class BayesOneMemcachedClassifier < BayesOneClassifier
  def initialize(memcache)
    super()
    @memcache = memcache
  end

  def fcount(feature, category)
    return shared_cache("fcount_#{feature}_#{category}") { super }
  end

  def catcount(category)
    return shared_cache("catcount_#{category}") { super }
  end

  def totalcount
    return shared_cache("totalcount") { super }
  end

  def categories
    return shared_cache("categories") { super }
  end

  private

  def shared_cache(key)
    value = @memcache.get(key)
    unless value
      value = yield
      @memcache.set(key, value, nil)
    end
    return value
  end
end

class BayesOneLocalCachedClassifier < BayesOneMemcachedClassifier
  def initialize(memcache)
    super(memcache)
    @cache = {}
  end

  def fcount(feature, category)
    return local_cache("fcount_#{feature}_#{category}") { super }
  end

  def catcount(category)
    return local_cache("catcount_#{category}") { super }
  end

  def totalcount
    return local_cache("totalcount") { super }
  end

  def categories
    return local_cache("categories") { super }
  end

  private

  def local_cache(key)
    value = @cache[key]
    unless value
      value = yield
      @cache[key] = value
    end
    return value
  end
end
