require 'test_helper'

class TextTest < Minitest::Test
  def test_each_fragment_enumerator
    text = Mindtrick::Text.new("abcd")
    assert_kind_of Enumerator, text.each_fragment
  end

  def test_each_fragment_map
    text = Mindtrick::Text.new(" abc de")
    expected = ['', 'a', 'ab', 'abc', 'abc ', 'abc d', 'abc de']
    result = text.each_fragment.map(&:to_s)
    assert_equal expected, result
  end

  def test_term
    text = Mindtrick::Text.new(" the dude \t abides. ")
    assert_equal text.term, "the dude abides."
  end

  def test_prefix
    text = Mindtrick::Text.new("bar")
    assert_equal text.prefixed('foo'), "foo:bar"
  end
end
