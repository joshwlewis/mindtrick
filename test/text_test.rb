require 'test_helper'

class TextTest < Minitest::Test
  def test_each_fragment_enumerator
    text = Mindtrick::Text.new("abcd")
    assert_kind_of Enumerator, text.each_fragment
  end

  def test_each_fragment_map
    text = Mindtrick::Text.new("abcd")
    expected = ['', 'a', 'ab', 'abc', 'abcd']
    result = text.each_fragment.map(&:to_s)
    assert_equal expected, result
  end
end
