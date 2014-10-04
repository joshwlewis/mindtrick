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
      term = Text.new(term)
      term.each_fragment do |f|
        if f.length <= max_length
          k = f.prefixed(prefix)
          redis.zincrby(k, 1, term)
          enforce_term_limit(k)
        end
      end
      term
    end

    def suggest(partial, count = 10)
      key = Text.new(partial).prefixed(prefix)
      redis.zrevrange key, 0, count
    end

    private

    def enforce_term_limit(partial)
      key = Text.new(partial).prefixed(prefix)
      if (over = redis.zcount(key, 0, '+inf') - max_terms) > 0
        partials = redis.zrange(key, 0, count * 3).sample(over)
        redis.zrem(k, partials)
      end
    end


  end
end
