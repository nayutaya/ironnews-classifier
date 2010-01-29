
# 「memcacheが適切に失効しない不具合」を修正するモンキーパッチ
# 対象はappengine-apis-0.0.12

module AppEngine
  class Memcache
    def put(key, value, expiration, mode)
      check_write
      convert_exceptions do
        key = memcache_key(key)
        value = memcache_value(value)
        expiration = memcache_expiration(expiration)
        service.put(key, value, expiration, mode)
      end
    end
  end
end
