
require "json"
require "digest/sha1"
require "dm-core"
require "dm-ar-finders"
require "appengine-apis/logger"
require "appengine-apis/urlfetch"
require "appengine-apis/memcache"

require "patch_memcache_mojibake"
require "patch_memcache_key"
require "patch_memcache_expiration"

DataMapper.setup(:default, "appengine://auto")

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

def sha1(value)
  return Digest::SHA1.hexdigest(value)
end

def cache(memcache, key)
  value = memcache.get(key)
  unless value
    value, ttl = yield
    memcache.set(key, value, ttl)
  end
  return value
end

get "/" do
  "ironnews-classifier"
end

require "bayes1/app"
