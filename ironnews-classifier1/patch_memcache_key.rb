
# 「memcacheで日本語キーが使用できない不具合」を修正するモンキーパッチ
# 対象はappengine-apis-0.0.12

module AppEngine
  class Memcache
    def memcache_key(obj)
      key = obj
      key = java.lang.String.new(key.to_s) if key
      key
    end

    class KeyMap
      def <<(key)
        @orig_keys << key
        string_key = if key
          key.to_s
        else
          key
        end
        @map[string_key] = key
        if string_key
          java.lang.String.new(string_key)
        else
          string_key
        end
      end

      def java_keys
        @map.keys.collect do |key|
          if key
            java.lang.String.new(key)
          else
            key
          end
        end
      end
    end
  end
end
