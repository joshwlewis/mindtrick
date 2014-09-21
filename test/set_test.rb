require 'test_helper'

class SetTest < Minitest::Test

  def setup
    @redis = Redis.new
    @key   = 'cmpl-tst'
    @set   = Mindtrick::Set.new(@redis, @key)
  end

  def test_add_and_search
    @set.add('foobar')
    assert_includes @set.search('foo'), 'foobar'
  end

  def teardown
    keys = @redis.keys("#{ @key }:*")
    @redis.del keys
  end

end
