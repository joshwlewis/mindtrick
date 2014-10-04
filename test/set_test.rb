require 'test_helper'

class SetTest < Minitest::Test

  attr_accessor :max_length, :max_terms
  def set
    Mindtrick::Set.new(redis: redis, prefix: prefix, max_length: max_length,
                       max_terms: max_terms)
  end

  def prefix
    @prefix ||= 'mndtrk-tst'
  end

  def redis
    @redis ||= Redis.new
  end

  def build_samples
    %w{fo foo foobar foobar foosball foosball foosball }.each do |term|
      set.add(term)
    end
  end


  def test_add
    set.add('qux')
    assert_includes set.suggest('q'), 'qux'
  end

  def test_suggest
    build_samples
    results = set.suggest "foo"
    assert_equal    results.first, 'foosball'
    assert_equal    results.last,  'foo'
    refute_includes results,       'fo'
  end

  def test_max_length_default
    self.max_length = nil
    assert stores_length(15)
    refute stores_length(16)
  end

  def test_max_length_option
    self.max_length = 4
    assert stores_length(4)
    refute stores_length(5)
  end

  def stores_length(l)
    phrase = random_string(l * 2)
    set.add(phrase)
    0 < redis.zcard("#{ prefix }:#{ phrase[0...l] }")
  end

  def test_max_terms_default
    self.max_terms = nil
    assert_max_terms(250)
  end

  def test_max_terms_option
    self.max_terms = 40
    assert_max_terms(40)
  end

  def assert_max_terms(max)
    (max + 25).times do
      set.add("foo#{ random_string(8) }")
    end
    assert_equal max, redis.zcount("#{ prefix }:foo", '-inf', '+inf')
  end

  def random_string(chars)
    (0...chars).map { (97 + rand(26)).chr }.join
  end

  def teardown
    keys = redis.keys("#{ prefix }:*")
    redis.del keys
  end

end
