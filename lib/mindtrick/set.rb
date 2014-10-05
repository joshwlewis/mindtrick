module Mindtrick
  class Set

    attr_reader :redis, :prefix, :max_terms, :max_length
    def initialize(opts = {})
      @redis      = opts[:redis]      || Redis.new
      @prefix     = opts[:prefix]     || 'mndtrk'
      @max_terms  = opts[:max_terms]  || 250
      @max_length = opts[:max_length] || 15
    end

    def add(term)
      fragmentize(term) do |k|
        redis.zincrby(k, 1, term)
        enforce_term_limit(k)
      end
    end

    def seed(term)
      fragmentize(term) do |k|
        unless redis.zscore(k, term)
          redis.zadd(k, 1, term)
          enforce_term_limit(k)
        end
      end
    end

    def fragmentize(term)
      term = Text.new(term)
      term.each_fragment do |f|
        if f.length <= max_length
          yield f.prefixed(prefix)
        else
          break
        end
      end
    end

    def suggest(partial, count = 10)
      key = Text.new(partial).prefixed(prefix)
      redis.zrevrange key, 0, count
    end

    private

    def enforce_term_limit(key)
      if (over = redis.zcount(key, 0, '+inf') - max_terms) > 0
        partials = redis.zrange(key, 0, over * 3).sample(over)
        redis.zrem(key, partials)
      end
    end


  end
end
