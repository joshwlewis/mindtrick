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
    phrase = 'the quick brown fox jumps over the lazy dog.'
    set.add(phrase)
    card = redis.zcard("#{ prefix }:#{ phrase[0..14] }")
    assert_equal card, 1
    card = redis.zcard("#{ prefix }:#{ phrase[0..15] }")
    assert_equal card, 0
  end

  def test_max_length_option
    self.max_length = 4
    phrase = 'the quick brown fox jumps over the lazy dog.'
    set.add(phrase)
    card = redis.zcard("#{ prefix }:#{ phrase[0..3] }")
    assert_equal card, 1
    card = redis.zcard("#{ prefix }:#{ phrase[0..4] }")
    assert_equal card, 0
  end

  def teardown
    keys = redis.keys("#{ prefix }:*")
    redis.del keys
  end

end
