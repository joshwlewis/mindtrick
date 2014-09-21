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
      value = normalize(term)
      key   = term.downcase
      length = [value.length, max_length].min
      (0..length).each do |l|
        k = add_prefix(key[0...l])
        enforce_term_limit(k, term)
        redis.zincrby(k, 1, term)
      end
      value
    end

    def search(term, count = 10)
      key = add_prefix(normalize(term).downcase)
      redis.zrevrange key, 0, count
    end

    private

    def enforce_term_limit(key, term)
      if (over = redis.zcount(key) - max_terms) > 0
        redis.zremrangebyrank(key, 0, over)
      end
    end

    def normalize(term)
      term.strip.gsub(/\s+/,' ')
    end

    def add_prefix(term)
      "#{ prefix }:#{ term }"
    end

  end
end
